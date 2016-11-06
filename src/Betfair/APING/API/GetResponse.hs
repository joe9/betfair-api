{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.GetResponse
  ( getResponse
  , getDecodedResponse
  , getResponseBodyText
  ) where

import           Control.Exception.Safe
import           Data.Aeson
import qualified Data.ByteString.Lazy    as L (ByteString)
import           Data.String.Conversions
import           Network.HTTP.Conduit    (HttpException (..),
                                          HttpExceptionContent (..),
                                          Request,
                                          Response (responseBody),
                                          Response (), httpLbs)
import           Protolude               hiding (throwIO, try)

import Betfair.APING.API.Context
import Betfair.APING.API.Log
import Betfair.APING.Types.BettingException

data ParserError =
  ParserError Text
  deriving (Eq, Read, Show, Typeable)

instance Exception ParserError

tryRequestAgain :: Context
                -> Request
                -> HttpException
                -> Int
                -> IO (Response L.ByteString)
tryRequestAgain c req e i
  | i > 9 = throwM e
  | otherwise =
    groomedLog
      c
      ("Betfair.APING.API.GetResponse.hs: HttpException - " <>
       show (e :: HttpException) <>
       " for " <>
       show i <>
       " attempts, Trying again" :: Text) >>
    tryForResponse c req (i + 1)

-- https://haskell-lang.org/tutorial/exception-safety
-- https://haskell-lang.org/library/safe-exceptions
-- http://neilmitchell.blogspot.com/2015/05/handling-control-c-in-haskell.html
-- the below exception handling mechanism is perfect. "try"
-- handles any synchronous exceptions and recovers from
-- them. Synchronous exceptions are exceptions directly related to
-- the executed code such as "no network connection", "no host",
-- etc.
tryForResponse :: Context -> Request -> Int -> IO (Response L.ByteString)
tryForResponse c req i = do
  eresponse <- try (httpLbs req (cManager c))
  case eresponse of
    Left e@(HttpExceptionRequest _ ResponseTimeout) -> tryRequestAgain c req e i
    -- let the caller deal with any other synchronous exception
    Left e -> throwM e
    Right response -> return response

getResponse :: Context -> Request -> IO (Response L.ByteString)
getResponse c req =
  groomedLog c =<< flip (tryForResponse c) 0 =<< groomedLog c req

getResponseBodyText :: Context -> Request -> IO Text
getResponseBodyText c req = fmap (cs . responseBody) (getResponse c req)

getDecodedResponse
  :: FromJSON a
  => Context -> Request -> IO a
getDecodedResponse c r =
  fmap responseBody (getResponse c r) >>=
  (\b -> (either (throwExceptions b) pure . decodeResponse) b)

bettingException :: L.ByteString -> Either ParserError BettingException
bettingException = either (Left . ParserError . cs) pure . eitherDecode

decodeResponse
  :: FromJSON a
  => L.ByteString -> Either ParserError a
decodeResponse = either (Left . ParserError . cs) pure . eitherDecode

throwExceptions
  :: (MonadThrow m)
  => L.ByteString -> ParserError -> m a
throwExceptions b e = (either (\_ -> throwM e) throwM . bettingException) b
