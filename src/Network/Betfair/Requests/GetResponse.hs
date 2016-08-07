{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.GetResponse
  (getResponse
  ,getDecodedResponse
  ,getResponseBodyText)
  where

import BasicPrelude hiding (try)
import Data.Aeson
import qualified Data.ByteString.Lazy as L (ByteString)
import Data.String.Conversions
import Control.Exception.Safe
import Network.HTTP.Conduit
       (HttpException(..), HttpExceptionContent(..), Request,
        Response(responseBody), Response(), httpLbs)

import Network.Betfair.Requests.Context
import Network.Betfair.Requests.WriterLog
import Network.Betfair.Types.BettingException (BettingException (..))

tryRequestAgain :: Context -> Request
                -> HttpException
                -> Int
                -> IO (Response L.ByteString)
tryRequestAgain c req e i
  | i > 9 = throwIO e
  | otherwise =
        groomedLog c
            ("Network.Betfair.Requests.GetResponse.hs: HttpException - "
             <> show (e :: HttpException)
             <> " for " <> (show i) <> " attempts, Trying again") >>
              tryForResponse c req (i + 1)

-- https://haskell-lang.org/tutorial/exception-safety
-- https://haskell-lang.org/library/safe-exceptions
-- http://neilmitchell.blogspot.com/2015/05/handling-control-c-in-haskell.html
-- the below exception handling mechanism is perfect. "try"
-- handles any synchronous exceptions and recovers from
-- them. Synchronous exceptions are exceptions directly related to
-- the executed code such as "no network connection", "no host",
-- etc.
tryForResponse
  :: Context -> Request -> Int -> IO (Response L.ByteString)
tryForResponse c req i =
  do eresponse <- try $ httpLbs req (cManager c)
     case eresponse of
       Left e@(HttpExceptionRequest _ ResponseTimeout) ->
         tryRequestAgain c req e i
       -- let the caller deal with any other synchronous exception
       Left e -> throwIO e
       Right response -> return response

getResponse
  :: Context -> Request -> IO (Response L.ByteString)
getResponse c req = groomedLog c =<< flip (tryForResponse c) 0 =<< groomedLog c req

getResponseBodyText :: Context -> Request -> IO Text
getResponseBodyText c req =
  fmap (cs . responseBody)
       (getResponse c req)

getDecodedResponse
  :: FromJSON a
  => Context -> Request -> IO (Either (Either Text BettingException) a)
getDecodedResponse c b =
  fmap (eitherDecodeAlsoCheckForBettingException . responseBody)
       (getResponse c b)

eitherDecodeAlsoCheckForBettingException
  :: FromJSON a
  => L.ByteString -> Either (Either Text BettingException) a
eitherDecodeAlsoCheckForBettingException b =
  case eitherDecode b of
    Left e ->
      case eitherDecode b :: Either String BettingException of
        Left _  -> (Left . Left . show) e
        Right v -> Left (Right v)
    Right a -> Right a
