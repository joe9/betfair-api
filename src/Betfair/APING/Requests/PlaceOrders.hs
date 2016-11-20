{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE DeriveGeneric        #-}
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

import qualified Data.Aeson                     as A (encode)
import           Data.Aeson.TH                  (Options (omitNothingFields),
                                                 defaultOptions,
                                                 deriveJSON)
import           Protolude
import           Text.PrettyPrint.GenericPretty

--
import Betfair.APING.API.APIRequest             (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse            (getDecodedResponse)
import Betfair.APING.API.Log                    (tracePPLog)
import Betfair.APING.Types.PlaceExecutionReport (PlaceExecutionReport)
import Betfair.APING.Types.PlaceInstruction     (PlaceInstruction)

data JsonRequest = JsonRequest
  { jsonrpc :: Text
  , method  :: Text
  , params  :: Maybe JsonParameters
  , id      :: Int
  } deriving (Eq, Show, Generic, Pretty)

data JsonParameters = JsonParameters
  { marketId     :: Text
  , instructions :: [PlaceInstruction]
  , customerRef  :: Text
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = JsonRequest "2.0" "SportsAPING/v1.0/placeOrders" (Just jp) 1

placeOrderWithParams :: Context -> JsonParameters -> IO PlaceExecutionReport
placeOrderWithParams c jp =
  tracePPLog c =<<
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
  tracePPLog c (JsonParameters mktid [pin] cref) >>= placeOrderWithParams c
