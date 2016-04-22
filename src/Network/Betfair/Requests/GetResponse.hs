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
import qualified Data.ByteString.Lazy      as L (ByteString)
import qualified Data.ByteString.Lazy.UTF8 as LUTF8 (toString)
import           Network.HTTP.Conduit      (HttpException (..),
                                            Manager, Request,
                                            Response (responseBody),
                                            Response (), httpLbs)

import Network.Betfair.Requests.WriterLog (Log, groomedLog)

continueOrError :: Request -> HttpException -> Int
                -> RWST r Log Manager IO (Response L.ByteString)
continueOrError req e@(ResponseTimeout) i =
  if i > 9
  then error $ "Network.Betfair.Requests.GetResponse.hs: HttpException - "
               ++ (show (e :: HttpException)) ++ " for 10 attempts"
  else groomedLog ("Network.Betfair.Requests.GetResponse.hs: HttpException - "
               ++ (show (e :: HttpException)) ++ " for " ++ (show i) ++ " attempts, Trying again")
        >> tryForResponse req (i + 1)
continueOrError _ e _ =
  error $ "Network.Betfair.Requests.GetResponse.hs: HttpException - "
               ++ (show (e :: HttpException))

tryForResponse :: Request -> Int -> RWST r Log Manager IO (Response L.ByteString)
tryForResponse req i = do
  manager <- get
  eresponse <- lift . try $ httpLbs req manager
  case eresponse of
      --         Left e -> print (e :: HttpException)
    Left e -> continueOrError req e i
    Right response -> return response

getResponse :: Request -> RWST r Log Manager IO (Response L.ByteString)
getResponse req = groomedLog =<< flip tryForResponse 0 =<< groomedLog req

getResponseBodyString :: Request -> RWST r Log Manager IO String
getResponseBodyString req =
 fmap (LUTF8.toString . responseBody) (getResponse req)

getResponseBody :: Request -> RWST r Log Manager IO L.ByteString
getResponseBody = fmap responseBody . getResponse
