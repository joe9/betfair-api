{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.Headers
  (headers)
  where

import Protolude
import Betfair.APING.Types.AppKey (AppKey)
import Betfair.APING.Types.Token  (Token)
import Network.HTTP.Types.Header  (RequestHeaders)

headers
  :: AppKey -> Maybe Token -> RequestHeaders
headers appKey Nothing =
  [("Accept","application/json")
  ,
   --     , (   "X-Application" ,   delayedAppKey )
   ("X-Application",show appKey)
  ,("Content-Type","application/json")
  ,
   -- below as recommended by Betfair "Best Practice"
   ("Accept-Encoding","gzip,deflate")
  ,
   -- this should not be necessary in HTTP 1.1 as keep-alive
   -- is the default. But, just adding it in to check if it
   -- makes a difference
   ("Connection","Keep-Alive")]
headers appKey (Just token) =
  ("X-Authentication",show token) : headers appKey Nothing
