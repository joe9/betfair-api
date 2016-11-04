{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Requests.KeepAlive
  ( keepAlive
  , KeepAlive(..)
  , keepAliveOnceEvery10Minutes
  ) where

import Control.Exception.Safe
import Data.Aeson
import Data.Aeson.TH
import Network.HTTP.Conduit
import Protolude

--
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse
import Betfair.APING.API.Headers
import Betfair.APING.Types.Token     (Token)

data KeepAlive = KeepAlive
  { token   :: Token
  , product :: Text
  , status  :: Status
    -- not converting this to type Error as I get a "" on success
    -- ,error   :: Error
  , error   :: Text
  } deriving (Eq, Read, Show, Typeable)

instance Exception KeepAlive

data Status
  = SUCCESS
  | FAIL
  deriving (Eq, Show, Read)

data Error
  = INPUT_VALIDATION_ERROR
  | INTERNAL_ERROR
  | NO_SESSION
  deriving (Eq, Show, Read)

$(deriveJSON defaultOptions {omitNothingFields = True} ''KeepAlive)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Status)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Error)

keepAliveRequest :: Context -> IO Request
keepAliveRequest c =
  (fmap
     (\req ->
        req
        { requestHeaders = headers (cAppKey c) (Just (cToken c))
        , method = "POST"
        }) .
   parseUrlThrow)
    "https://identitysso.betfair.com/api/keepAlive"

-- KeepAlive - Just send a KeepAlive and forget about it. If there is
-- a problem with the KeepAlive, then it is a bigger issue and
-- should raise an exception, so the whole connection can be reset
keepAlive :: Context -> IO KeepAlive
keepAlive c = checkStatus =<< getDecodedResponse c =<< keepAliveRequest c

checkStatus :: KeepAlive -> IO KeepAlive
checkStatus k
  | status k == FAIL = throwM k
  | otherwise = return k

-- according to the docs, italian exchange timesout in 15 mins. Hence,
-- using 10 minute intervals
-- call this in a separate thread. It is a never ending loop
keepAliveOnceEvery10Minutes :: Context -> IO KeepAlive
keepAliveOnceEvery10Minutes context =
  keepAlive context *> threadDelay (10 * 60 * 1000 * 1000) *>
  keepAliveOnceEvery10Minutes context
