{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.GetResponse
   ( getResponse
   , getResponseBody
   , getResponseBodyString
   ) where

-- import qualified Data.ByteString.UTF8 as B
import           Control.Exception         (try)
import           Control.Monad.RWS
import qualified Data.Aeson                as A (decode)
import qualified Data.ByteString.Lazy      as L (ByteString)
import qualified Data.ByteString.Lazy.UTF8 as LUTF8 (toString)
import           Data.Maybe                (isJust)
import           Network.HTTP.Conduit      (HttpException (..),
                                            HttpExceptionContent (..),
                                            Manager, Request,
                                            Response (responseBody),
                                            Response (), httpLbs)

import Network.Betfair.Requests.WriterLog     (Log, groomedLog)
import Network.Betfair.Types.BettingException (BettingException (..))

continueOrFail :: Request -> HttpException -> Int
                   -> RWST r Log Manager IO (Response L.ByteString)
continueOrFail req e@(HttpExceptionRequest _ ResponseTimeout) i =
  if i > 9
  then fail $ "Network.Betfair.Requests.GetResponse.hs: HttpException - "
                  ++ (show (e :: HttpException)) ++ " for 10 attempts"
  else groomedLog ("Network.Betfair.Requests.GetResponse.hs: HttpException - "
               ++ (show (e :: HttpException)) ++ " for " ++ (show i) ++ " attempts, Trying again")
        >> tryForResponse req (i + 1)
continueOrFail _ e _ =
  fail $ "Network.Betfair.Requests.GetResponse.hs: HttpException - "
                  ++ (show (e :: HttpException))

tryForResponse :: Request -> Int -> RWST r Log Manager IO (Response L.ByteString)
tryForResponse req i = do
  manager <- get
  eresponse <- lift . try $ httpLbs req manager
  case eresponse of
    Left e -> continueOrFail req e i
    Right response -> return response

getResponse :: Request -> RWST r Log Manager IO (Response L.ByteString)
getResponse req = groomedLog =<< flip tryForResponse 0 =<< groomedLog req

getResponseBodyString :: Request -> RWST r Log Manager IO String
getResponseBodyString req =
 fmap (LUTF8.toString . responseBody) (getResponse req)

getResponseBody :: Request -> RWST r Log Manager IO L.ByteString
getResponseBody b =
   fmap responseBody (getResponse b) >>= failOnBettingException

failOnBettingException :: L.ByteString -> RWST r Log Manager IO L.ByteString
failOnBettingException b
  | hasBettingException b =
     fail $ "Network.Betfair.Requests.GetResponse.hs: BettingException: "
            ++ show b
            ++ ", parsed as: "
            ++ show (bettingException b)
  | otherwise = return b

bettingException :: L.ByteString -> Maybe BettingException
bettingException = A.decode

hasBettingException :: L.ByteString -> Bool
hasBettingException = isJust . bettingException
