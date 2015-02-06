{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.Logout
   ( logout
   ) where

import Control.Monad.RWS
import Network.HTTP.Conduit

import Network.Betfair.Requests.GetResponse
import Network.Betfair.Requests.Headers
import Network.Betfair.Requests.ParseLogout
import Network.Betfair.Requests.WriterLog   (Log)
import Network.Betfair.Types.AppKey
import Network.Betfair.Types.Token          (Token)

logoutRequest :: RWST (AppKey, Token) Log s IO Request
logoutRequest =
  (\(a,t) -> lift . fmap (\req -> req { requestHeaders = headers a (Just t)
                                    -- no need of B.fromString below due
                                    -- to overloadedStrings extension
                                    , method = "POST"
                                    })
         $ parseUrl "https://identitysso.betfair.com/api/logout"
  ) =<< ask

logout :: RWST (AppKey,Token) Log Manager IO Logout
logout = fmap getLogout . getResponseBodyString =<< logoutRequest
