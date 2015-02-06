{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.APIRequest
   ( apiRequest
   , apiRequestString
   ) where

import Control.Monad.RWS         (MonadReader (ask),
                                  MonadTrans (lift), RWST)
import Data.ByteString.Lazy      (ByteString)
import Data.ByteString.Lazy.UTF8 (fromString)
import Network.HTTP.Conduit      (Request (method, requestBody, requestHeaders),
                                  RequestBody (RequestBodyLBS),
                                  parseUrl)

import Network.Betfair.Requests.Headers   (headers)
import Network.Betfair.Requests.WriterLog (Log)
import Network.Betfair.Types.AppKey       (AppKey)
import Network.Betfair.Types.Token        (Token)

apiRequest :: ByteString -> RWST (AppKey, Token) Log s IO Request
apiRequest jsonBody =
  (\(a,t) -> lift . fmap (\req -> req { requestHeaders = headers a (Just t)
                                    -- no need of B.fromString below due
                                    -- to overloadedStrings extension
                                    , method = "POST"
                                    , requestBody =
                                         RequestBodyLBS jsonBody
                                    })
         $ parseUrl "https://api.betfair.com/exchange/betting/json-rpc/v1"
  ) =<< ask

apiRequestString :: String -> RWST (AppKey, Token) Log s IO Request
apiRequestString s = apiRequest (fromString s)
