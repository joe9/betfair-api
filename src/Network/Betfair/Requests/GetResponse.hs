{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.GetResponse
   ( getResponse
   , getResponseBody
   , getResponseBodyString
   ) where

-- import qualified Data.ByteString.UTF8 as B
import           Control.Monad.RWS
import qualified Data.ByteString.Lazy               as L (ByteString)
import qualified Data.ByteString.Lazy.UTF8          as LUTF8 (toString)
import           Data.Default                       (Default (def))
import           Network.Connection                 (ProxySettings (SockSettingsSimple))
import           Network.HTTP.Conduit               (Manager,
                                                     ManagerSettings,
                                                     Request, Response (responseBody),
                                                     httpLbs, mkManagerSettings)

import           Network.Betfair.Requests.WriterLog (Log, groomedLog)

getResponse :: Request -> RWST r Log Manager IO (Response L.ByteString)
getResponse req =
  groomedLog
  =<< lift . httpLbs req
  =<< (\_ -> get)
  =<< groomedLog req

getResponseBodyString :: Request -> RWST r Log Manager IO String
getResponseBodyString req =
 fmap (LUTF8.toString . responseBody) (getResponse req)

getResponseBody :: Request -> RWST r Log Manager IO L.ByteString
getResponseBody = fmap responseBody . getResponse
