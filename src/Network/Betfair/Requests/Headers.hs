{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Headers
  (headers
  ,bs)
  where

--    , cibs
import qualified Data.ByteString.UTF8         as B (ByteString,
                                                    fromString)
import qualified Data.CaseInsensitive         as CI (CI, mk)
import           Network.Betfair.Types.AppKey (AppKey)
import           Network.Betfair.Types.Token  (Token)
import           Network.HTTP.Types.Header    (RequestHeaders)

headers
  :: AppKey -> Maybe Token -> RequestHeaders
headers appKey Nothing =
  [(cibs "Accept",bs "application/json")
  ,
   --     , ( cibs "X-Application" , bs delayedAppKey )
   (cibs "X-Application",bs appKey)
  ,(cibs "Content-Type",bs "application/json")
  ,
   -- below as recommended by Betfair "Best Practice"
   (cibs "Accept-Encoding",bs "gzip,deflate")
  ,
   -- this should not be necessary in HTTP 1.1 as keep-alive
   -- is the default. But, just adding it in to check if it
   -- makes a difference
   (cibs "Connection",bs "Keep-Alive")]
headers appKey (Just token) =
  (cibs "X-Authentication",bs token) : headers appKey Nothing

cibs :: String -> CI.CI B.ByteString
cibs = CI.mk . B.fromString

bs :: String -> B.ByteString
bs = B.fromString
