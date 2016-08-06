{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.APIRequest
  (apiRequest
  ,apiRequestString)
  where

import           BasicPrelude
import qualified Data.ByteString.Lazy             as L
import           Data.String.Conversions
import           Network.HTTP.Conduit             (Request (method, requestBody, requestHeaders),
                                                   RequestBody (RequestBodyLBS),
                                                   parseUrlThrow)


import           Network.Betfair.Requests.Context
import           Network.Betfair.Requests.Headers (headers)

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
apiRequestString c s =
  apiRequest c
             (cs s)
