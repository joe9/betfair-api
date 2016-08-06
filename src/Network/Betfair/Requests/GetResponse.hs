{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.GetResponse
  (getResponse
  ,getResponseBody
  ,getResponseBodyString)
  where

import           Control.Exception.Safe
import           Control.Monad.RWS
import           Data.Aeson
import qualified Data.ByteString.Lazy                   as L (ByteString)
import qualified Data.ByteString.Lazy.UTF8              as LUTF8 (toString)
import           Network.Betfair.Requests.WriterLog     (Log,
                                                         groomedLog)
import           Network.Betfair.Types.BettingException (BettingException (..))
import           Network.HTTP.Conduit                   (HttpException (..),
                                                         HttpExceptionContent (..),
                                                         Manager,
                                                         Request,
                                                         Response (responseBody),
                                                         Response (),
                                                         httpLbs)

tryRequestAgain
  :: Request
  -> HttpException
  -> Int
  -> RWST r Log Manager IO (Response L.ByteString)
tryRequestAgain req e i
  | i > 9 = throwM e
  | otherwise =
    groomedLog
      ("Network.Betfair.Requests.GetResponse.hs: HttpException - " ++
       (show (e :: HttpException)) ++
       " for " ++ (show i) ++ " attempts, Trying again") >>
    tryForResponse req
                   (i + 1)

-- https://haskell-lang.org/tutorial/exception-safety
-- https://haskell-lang.org/library/safe-exceptions
-- http://neilmitchell.blogspot.com/2015/05/handling-control-c-in-haskell.html
-- the below exception handling mechanism is perfect. "try"
-- handles any synchronous exceptions and recovers from
-- them. Synchronous exceptions are exceptions directly related to
-- the executed code such as "no network connection", "no host",
-- etc.
tryForResponse
  :: Request -> Int -> RWST r Log Manager IO (Response L.ByteString)
tryForResponse req i =
  do manager <- get
     eresponse <- lift . try $ httpLbs req manager
     case eresponse of
       Left e@(HttpExceptionRequest _ ResponseTimeout) ->
         tryRequestAgain req e i
       -- let the caller deal with any other synchronous exception
       Left e -> throwM e
       Right response -> return response

getResponse
  :: Request -> RWST r Log Manager IO (Response L.ByteString)
getResponse req = groomedLog =<< flip tryForResponse 0 =<< groomedLog req

getResponseBodyString
  :: Request -> RWST r Log Manager IO String
getResponseBodyString req =
  fmap (LUTF8.toString . responseBody)
       (getResponse req)

getResponseBody
  :: FromJSON a
  => Request
  -> RWST r Log Manager IO (Either (Either String BettingException) a)
getResponseBody b =
  fmap (eitherDecodeAlsoCheckForBettingException . responseBody)
       (getResponse b)

eitherDecodeAlsoCheckForBettingException
  :: FromJSON a
  => L.ByteString -> Either (Either String BettingException) a
eitherDecodeAlsoCheckForBettingException b =
  case eitherDecode b of
    Left e ->
      case eitherDecode b :: Either String BettingException of
        Left _  -> Left (Left e)
        Right v -> Left (Right v)
    Right a -> Right a
