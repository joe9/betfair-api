{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Requests.KeepAlive
  (keepAlive
  ,KeepAlive(..))
  where

import Control.Monad.RWS
import Data.Aeson
import Data.Aeson.TH
import Network.Betfair.Requests.GetResponse
import Network.Betfair.Requests.Headers
import Network.Betfair.Requests.WriterLog   (Log)
import Network.Betfair.Types.AppKey
import Network.Betfair.Types.Token          (Token)
import Network.Betfair.Types.BettingException
import Network.HTTP.Conduit
import Prelude                              hiding (error)

data KeepAlive =
  KeepAlive {token   :: Token
            ,product :: String
            ,status  :: Status
            ,error   :: Error}
  deriving (Eq,Read,Show)

data Status
  = SUCCESS
  | FAIL
  deriving (Eq,Show,Read)

data Error
  = INPUT_VALIDATION_ERROR
  | INTERNAL_ERROR
  | NO_SESSION
  deriving (Eq,Show,Read)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''KeepAlive)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Status)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Error)

keepAliveRequest
  :: RWST (AppKey,Token) Log s IO Request
keepAliveRequest =
  (\(a,t) ->
     (lift .
      fmap (\req ->
              req {requestHeaders = headers a (Just t)
                  ,method = "POST"}) .
      parseUrlThrow) "https://identitysso.betfair.com/api/keepAlive") =<<
  ask

keepAlive
  :: RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) KeepAlive)
keepAlive = getResponseBody =<< keepAliveRequest
