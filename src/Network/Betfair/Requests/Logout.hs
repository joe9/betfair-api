{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Requests.Logout
  (logout
  ,Logout(..))
  where

import Control.Monad.RWS
import Data.Aeson
import Data.Aeson.TH
import Network.Betfair.Requests.GetResponse
import Network.Betfair.Requests.Headers
import Network.Betfair.Requests.WriterLog     (Log)
import Network.Betfair.Types.AppKey
import Network.Betfair.Types.BettingException
import Network.Betfair.Types.Token            (Token)
import Network.HTTP.Conduit
import Prelude                                hiding (error)

data Logout =
  Logout {token   :: Token
         ,product :: String
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

logoutRequest
  :: RWST (AppKey,Token) Log s IO Request
logoutRequest =
  (\(a,t) ->
     (lift .
      fmap (\req ->
              req {requestHeaders = headers a (Just t)
                  ,method = "POST"}) .
      parseUrlThrow) "https://identitysso.betfair.com/api/logout") =<<
  ask

logout
  :: RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) Logout)
logout = getDecodedResponse =<< logoutRequest
