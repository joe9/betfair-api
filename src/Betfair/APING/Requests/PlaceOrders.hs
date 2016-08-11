{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.PlaceOrders
  (placeOrder
  ,placeOrderWithParams
  ,JsonParameters(..)
  ,JsonRequest(..))
  where

import           BasicPrelude
import           Betfair.APING.API.APIRequest             (apiRequest)
import           Betfair.APING.API.Context
import           Betfair.APING.API.GetResponse            (getDecodedResponse)
import           Betfair.APING.API.ResponseException
import           Betfair.APING.API.Log              (groomedLog)
import           Betfair.APING.Types.PlaceExecutionReport (PlaceExecutionReport)
import           Betfair.APING.Types.PlaceInstruction     (PlaceInstruction)
import           Betfair.APING.Types.ResponsePlaceOrders  (Response (result))
import qualified Data.Aeson                               as A (encode)
import           Data.Aeson.TH                            (Options (omitNothingFields),
                                                           defaultOptions,
                                                           deriveJSON)
import           Data.Default                             (Default (..))

data JsonRequest =
  JsonRequest {jsonrpc :: Text
              ,method  :: Text
              ,params  :: Maybe JsonParameters
              ,id      :: Int}
  deriving (Eq,Show)

instance Default JsonRequest where
  def =
    JsonRequest "2.0"
                "SportsAPING/v1.0/placeOrders"
                (Just def)
                1

data JsonParameters =
  JsonParameters {marketId     :: Text
                 ,instructions :: [PlaceInstruction]
                 ,customerRef  :: Text}
  deriving (Eq,Show)

-- deriveDefault ''JsonParameters
instance Default JsonParameters where
  def = JsonParameters "" [] ""

-- instance Default JsonParameters where
--  def = JsonParameters def def def
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

placeOrderWithParams
  :: Context
  -> JsonParameters
  -> IO (Either ResponseException PlaceExecutionReport)
placeOrderWithParams c jp =
  groomedLog c =<<
  fmap (either Left (Right . result)) . getDecodedResponse c =<<
  apiRequest c
             (A.encode $ jsonRequest jp)

type CustomerRef = Text

type MarketId = Text

placeOrder
  :: Context
  -> MarketId
  -> PlaceInstruction
  -> CustomerRef
  -> IO (Either ResponseException PlaceExecutionReport)
placeOrder c mktid pin cref =
  groomedLog
    c
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  placeOrderWithParams c
