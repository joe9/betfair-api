{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.APIRequest
  (apiRequest
  ,apiRequestString)
  where

import           Protolude
import           Betfair.APING.API.Context
import           Betfair.APING.API.Headers (headers)
import qualified Data.ByteString.Lazy      as L
import           Network.HTTP.Conduit      (Request (method, requestBody, requestHeaders),
                                            RequestBody (RequestBodyLBS),
                                            parseUrlThrow)

apiRequest
  :: Context -> L.ByteString -> IO Request
apiRequest c jsonBody =
  fmap (\req ->
          req {requestHeaders =
                 headers (cAppKey c)
                         (Just (cToken c))
              ,method = "POST"
              ,requestBody = RequestBodyLBS jsonBody})
       (parseUrlThrow "https://api.betfair.com/exchange/betting/json-rpc/v1")

apiRequestString :: Context -> Text -> IO Request
apiRequestString c s = apiRequest c (toS s)
