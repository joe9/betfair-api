{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Requests.KeepAlive
  (keepAlive
  ,KeepAlive(..))
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
