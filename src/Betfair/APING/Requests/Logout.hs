{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Requests.Logout
  ( logout
  , Logout(..)
  ) where

import Control.Exception.Safe
import Data.Aeson
import Data.Aeson.TH
import Protolude

--
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse
import Betfair.APING.API.Headers
import Betfair.APING.Types.Token     (Token)
import Network.HTTP.Conduit

data Logout = Logout
  { token   :: Token
  , product :: Text
  , status  :: Status
    -- not converting this to type Error as I get a "" on success
    -- ,error   :: Error
  , error   :: Text
  } deriving (Eq, Read, Show)

data Status
  = SUCCESS
  | FAIL
  deriving (Eq, Read, Show)

data Error
  = INPUT_VALIDATION_ERROR
  | INTERNAL_ERROR
  | NO_SESSION
  deriving (Eq, Read, Show)

instance Exception Logout

$(deriveJSON defaultOptions {omitNothingFields = True} ''Logout)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Status)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Error)

logoutRequest :: Context -> IO Request
logoutRequest c =
  (fmap
     (\req ->
        req
        { requestHeaders = headers (cAppKey c) (Just (cToken c))
        , method = "POST"
        }) .
   parseUrlThrow)
    "https://identitysso.betfair.com/api/logout"

logout :: Context -> IO Logout
logout c = checkStatus =<< getDecodedResponse c =<< logoutRequest c

checkStatus :: Logout -> IO Logout
checkStatus k
  | status k == FAIL = throwM k
  | otherwise = return k
