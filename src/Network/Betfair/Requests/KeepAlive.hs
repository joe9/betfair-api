{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.KeepAlive
   ( keepAliveRequest
   , keepAlive
   ) where

import qualified Data.ByteString.Lazy                    as L
import           Network.HTTP.Conduit

import           Network.Betfair.Requests.GetResponse
import           Network.Betfair.Requests.Headers
import           Network.Betfair.Requests.Login
import           Network.Betfair.Requests.ParseKeepAlive
import           Network.Betfair.Types.Token             (Token)

keepAliveRequest :: Token -> IO Request
keepAliveRequest t =
 parseUrl "https://identitysso.betfair.com/api/keepAlive"
   >>= (\req -> return $ req {requestHeaders = headers (Just t)})

keepAlive :: Token -> IO (Response L.ByteString)
keepAlive t = keepAliveRequest t >>= getResponse
