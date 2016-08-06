{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.PlaceOrders
  (placeOrder
  ,placeOrderWithParams
  ,JsonParameters(..)
  ,JsonRequest(..))
  where

import           BasicPrelude
import qualified Data.Aeson                                 as A (encode)
import           Data.Aeson.TH                              (Options (omitNothingFields),
                                                             defaultOptions,
                                                             deriveJSON)
import           Data.Default                               (Default (..))

import           Network.Betfair.Requests.APIRequest        (apiRequest)
import           Network.Betfair.Requests.GetResponse       (getDecodedResponse)
import           Network.Betfair.Requests.WriterLog         (groomedLog)
import           Network.Betfair.Requests.Context
import           Network.Betfair.Types.BettingException
import           Network.Betfair.Types.PlaceExecutionReport (PlaceExecutionReport)
import           Network.Betfair.Types.PlaceInstruction     (PlaceInstruction)
import           Network.Betfair.Types.ResponsePlaceOrders  (Response (result))

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
  :: Context -> JsonParameters
  -> IO (Either (Either Text BettingException) PlaceExecutionReport)
placeOrderWithParams c jp =
  groomedLog c =<<
  fmap (either Left (Right . result)) . getDecodedResponse c =<<
  apiRequest c (A.encode $ jsonRequest jp)

type CustomerRef = Text

type MarketId = Text

placeOrder
  :: Context -> MarketId
  -> PlaceInstruction
  -> CustomerRef
  -> IO (Either (Either Text BettingException) PlaceExecutionReport)
placeOrder c mktid pin cref =
  groomedLog c
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  placeOrderWithParams c

