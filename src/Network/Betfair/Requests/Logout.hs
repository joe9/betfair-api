{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Requests.Logout
  (logout
  ,Logout(..))
  where

import BasicPrelude
import Data.Aeson
import Data.Aeson.TH
import Network.HTTP.Conduit

import Network.Betfair.Requests.Context
import Network.Betfair.Requests.GetResponse
import Network.Betfair.Requests.Headers
import Network.Betfair.Types.BettingException
import Network.Betfair.Types.Token            (Token)

data Logout =
  Logout {token   :: Token
         ,product :: Text
         ,status  :: Status
         ,error   :: Maybe Error}
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
  :: Context -> IO (Either (Either Text BettingException) Logout)
logout c = getDecodedResponse c =<< logoutRequest c
