{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Headers
   ( headers
   , bs
   , AppKey
--    , cibs
   ) where

import qualified Data.ByteString.UTF8        as B (ByteString,
                                                   fromString)
import qualified Data.CaseInsensitive        as CI (CI, mk)
import           Network.HTTP.Types.Header   (RequestHeaders)

import           Network.Betfair.Types.Token (Token)

type AppKey = String

headers :: AppKey -> Maybe Token -> RequestHeaders
headers appKey Nothing =
    [ ( cibs "Accept"        , bs "application/json" )
--     , ( cibs "X-Application" , bs delayedAppKey )
    , ( cibs "X-Application" , bs appKey )
    , ( cibs "Content-Type"  , bs "application/json" )
    ]
headers appKey (Just token) =
    ( cibs "X-Authentication" , bs token )
       : headers appKey Nothing

cibs :: String -> CI.CI B.ByteString
cibs = CI.mk . B.fromString

bs :: String -> B.ByteString
bs   = B.fromString
