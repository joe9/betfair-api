{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Requests.Logout
  (logout
  ,Logout(..))
  where

import BasicPrelude
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse
import Betfair.APING.API.Headers
import Betfair.APING.API.ResponseException
import Betfair.APING.Types.Token           (Token)
import Data.Aeson
import Data.Aeson.TH
import Network.HTTP.Conduit

data Logout =
  Logout {token :: Token
         ,product :: Text
         ,status :: Status
         ,error :: Maybe Error}
  deriving (Eq,Read,Show)

data Status
  = SUCCESS
  | FAIL
  deriving (Eq,Read,Show)

data Error
  = INPUT_VALIDATION_ERROR
  | INTERNAL_ERROR
  | NO_SESSION
  deriving (Eq,Read,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Logout)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Status)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Error)

logoutRequest :: Context -> IO Request
logoutRequest c =
  (fmap (\req ->
           req {requestHeaders =
                  headers (cAppKey c)
                          (Just (cToken c))
               ,method = "POST"}) .
   parseUrlThrow) "https://identitysso.betfair.com/api/logout"

logout
  :: Context -> IO (Either ResponseException Logout)
logout c = getDecodedResponse c =<< logoutRequest c
