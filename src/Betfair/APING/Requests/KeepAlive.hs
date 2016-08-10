{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Requests.KeepAlive
  (keepAlive
  ,KeepAlive(..))
  where

import BasicPrelude
import Data.Aeson
import Data.Aeson.TH
import Network.HTTP.Conduit

import Betfair.APING.Requests.Context
import Betfair.APING.Requests.GetResponse
import Betfair.APING.Requests.Headers
import Betfair.APING.Requests.ResponseException
import Betfair.APING.Types.Token            (Token)

data KeepAlive =
  KeepAlive {token   :: Token
            ,product :: Text
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

keepAliveRequest :: Context -> IO Request
keepAliveRequest c =
  (fmap (\req ->
           req {requestHeaders =
                  headers (cAppKey c)
                          (Just (cToken c))
               ,method = "POST"}) .
   parseUrlThrow) "https://identitysso.betfair.com/api/keepAlive"

keepAlive
  :: Context -> IO (Either ResponseException KeepAlive)
keepAlive c = getDecodedResponse c =<< keepAliveRequest c
