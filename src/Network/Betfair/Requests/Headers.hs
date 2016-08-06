{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.Headers
  (headers)
  where

import BasicPrelude
import Data.String.Conversions
import Network.Betfair.Types.AppKey (AppKey)
import Network.Betfair.Types.Token  (Token)
import Network.HTTP.Types.Header    (RequestHeaders)

headers
  :: AppKey -> Maybe Token -> RequestHeaders
headers appKey Nothing =
  [("Accept","application/json")
  ,
   --     , (   "X-Application" ,   delayedAppKey )
   ("X-Application",cs appKey)
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
  ("X-Authentication",cs token) : headers appKey Nothing
