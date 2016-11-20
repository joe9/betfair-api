{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.APIRequest
  ( apiRequest
  , apiRequestString
  ) where

import qualified Data.ByteString.Lazy           as L
import           Data.String.Conversions
import           Network.HTTP.Conduit           (Request (method, requestBody, requestHeaders),
                                                 RequestBody (RequestBodyLBS),
                                                 parseUrlThrow)
import           Protolude
import           Text.PrettyPrint.GenericPretty

import Betfair.APING.API.Context
import Betfair.APING.API.Headers (headers)

apiRequest :: Context -> L.ByteString -> IO Request
apiRequest c jsonBody =
  fmap
    (\req ->
       req
       { requestHeaders = headers (cAppKey c) (Just (cToken c))
       , method = "POST"
       , requestBody = RequestBodyLBS jsonBody
       })
    (parseUrlThrow "https://api.betfair.com/exchange/betting/json-rpc/v1")

apiRequestString :: Context -> Text -> IO Request
apiRequestString c s = apiRequest c (cs s)
