{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.PlaceOrders
  ( placeOrder
  , placeOrderWithParams
  , JsonParameters(..)
  , JsonRequest(..)
  ) where

import qualified Data.Aeson    as A (encode)
import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)
import           Protolude

--
import Betfair.APING.API.APIRequest             (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse            (getDecodedResponse)
import Betfair.APING.API.Log                    (groomedLog)
import Betfair.APING.Types.PlaceExecutionReport (PlaceExecutionReport)
import Betfair.APING.Types.PlaceInstruction     (PlaceInstruction)

data JsonRequest = JsonRequest
  { jsonrpc :: Text
  , method  :: Text
  , params  :: Maybe JsonParameters
  , id      :: Int
  } deriving (Eq, Show)

data JsonParameters = JsonParameters
  { marketId     :: Text
  , instructions :: [PlaceInstruction]
  , customerRef  :: Text
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = JsonRequest "2.0" "SportsAPING/v1.0/placeOrders" (Just jp) 1

placeOrderWithParams :: Context -> JsonParameters -> IO PlaceExecutionReport
placeOrderWithParams c jp =
  groomedLog c =<<
  getDecodedResponse c =<< apiRequest c (A.encode $ jsonRequest jp)

type CustomerRef = Text

type MarketId = Text

placeOrder
  :: Context
  -> MarketId
  -> PlaceInstruction
  -> CustomerRef
  -> IO PlaceExecutionReport
placeOrder c mktid pin cref =
  groomedLog c (JsonParameters mktid [pin] cref) >>= placeOrderWithParams c
