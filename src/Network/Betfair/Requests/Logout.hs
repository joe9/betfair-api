{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Logout
   ( logoutRequest
   , logout
   ) where

import qualified Data.ByteString.Lazy                 as L
import           Network.HTTP.Conduit

import           Network.Betfair.Requests.GetResponse
import           Network.Betfair.Requests.Headers
import           Network.Betfair.Requests.Login
import           Network.Betfair.Requests.ParseLogout
import           Network.Betfair.Types.Token          (Token)

logoutRequest :: Token -> IO Request
logoutRequest t =
 parseUrl "https://identitysso.betfair.com/api/logout"
   >>= (\req -> return $ req {requestHeaders = headers (Just t)})

logout :: Token -> IO (Response L.ByteString)
logout t = logoutRequest t >>= getResponse
