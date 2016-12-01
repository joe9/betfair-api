{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING
  ( Context(..)
  , initializeContext
   -- GetResponse
  , getDecodedResponse
   -- Requests
   -- Login
  , sessionToken
   -- Logout
  , logout
   -- PlaceOrders
  , placeOrder
  , placeOrderWithParams
   -- KeepAlive
  , keepAlive
  , keepAliveOnceEvery10Minutes
   -- ListMarketBook
  , listMarketBook
  , marketBook
  , marketBooks
   -- ListMarketCatalogue
  , marketCatalogue
   -- CancelOrders
  , cancelOrder
  , cancelOrderWithParams
   -- Types
  , APINGException
  , AppKey
  , BettingException
  , CancelExecutionReport
  , CancelInstruction
  , CancelInstructionReport
  , Competition
  , Error
  , ErrorData
  , Event
  , EventType
  , ExBestOffersOverrides
  , ExchangePrices
  , ExecutionReportErrorCode
  , ExecutionReportStatus
  , InstructionReportErrorCode
  , InstructionReportStatus
  , LimitOnCloseOrder
  , LimitOrder
  , Login
  , MarketBettingType
  , MarketBook
  , MarketCatalogue
  , MarketDescription
  , MarketFilter
  , MarketOnCloseOrder
  , MarketProjection
  , MarketSort
  , MarketStatus
  , Match
  , MatchProjection
  , Order
  , OrderProjection
  , OrderStatus
  , OrderType
  , PersistenceType
  , PlaceExecutionReport
  , PlaceInstruction
  , PlaceInstructionReport
  , PriceData
  , PriceProjection
  , PriceSize
   --   ,ResponseCancelOrders
   --   ,ResponseMarketBook
   --   ,ResponseMarketCatalogue
   --   ,ResponsePlaceOrders
  , RollupModel
  , Runner
  , RunnerCatalog
  , RunnerStatus
  , Side
  , StartingPrices
  , TimeRange
  , Token
  -- common types
  , SelectionId
  , MarketId
  , EventName
  , MarketName
  , RunnerName
  , PointId
  , Price
  , Size
  ) where

import Protolude

-- API
-- Context
-- import Betfair.APING.API.APIRequest
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse

-- import Betfair.APING.API.Headers
-- import Betfair.APING.API.Log
import Betfair.APING.Requests.CancelOrders
import Betfair.APING.Requests.KeepAlive
import Betfair.APING.Requests.ListMarketBook
import Betfair.APING.Requests.ListMarketCatalogue
import Betfair.APING.Requests.Login
import Betfair.APING.Requests.Logout
import Betfair.APING.Requests.PlaceOrders
import Betfair.APING.Types.APINGException
import Betfair.APING.Types.AppKey
import Betfair.APING.Types.BettingException
import Betfair.APING.Types.CancelExecutionReport
import Betfair.APING.Types.CancelInstruction
import Betfair.APING.Types.CancelInstructionReport
import Betfair.APING.Types.Competition
import Betfair.APING.Types.Error
import Betfair.APING.Types.ErrorData
import Betfair.APING.Types.Event
import Betfair.APING.Types.EventType
import Betfair.APING.Types.ExBestOffersOverrides
import Betfair.APING.Types.ExchangePrices
import Betfair.APING.Types.ExecutionReportErrorCode
import Betfair.APING.Types.ExecutionReportStatus
import Betfair.APING.Types.InstructionReportErrorCode
import Betfair.APING.Types.InstructionReportStatus
import Betfair.APING.Types.LimitOnCloseOrder
import Betfair.APING.Types.LimitOrder
import Betfair.APING.Types.Login
import Betfair.APING.Types.MarketBettingType
import Betfair.APING.Types.MarketBook
import Betfair.APING.Types.MarketCatalogue
import Betfair.APING.Types.MarketDescription
import Betfair.APING.Types.MarketFilter
import Betfair.APING.Types.MarketOnCloseOrder
import Betfair.APING.Types.MarketProjection
import Betfair.APING.Types.MarketSort
import Betfair.APING.Types.MarketStatus
import Betfair.APING.Types.Match
import Betfair.APING.Types.MatchProjection
import Betfair.APING.Types.Order
import Betfair.APING.Types.OrderProjection
import Betfair.APING.Types.OrderStatus
import Betfair.APING.Types.OrderType
import Betfair.APING.Types.PersistenceType
import Betfair.APING.Types.PlaceExecutionReport
import Betfair.APING.Types.PlaceInstruction
import Betfair.APING.Types.PlaceInstructionReport
import Betfair.APING.Types.PriceData
import Betfair.APING.Types.PriceProjection
import Betfair.APING.Types.PriceSize

-- import Betfair.APING.Types.ResponseCancelOrders
-- import Betfair.APING.Types.ResponseMarketBook
-- import Betfair.APING.Types.ResponseMarketCatalogue
-- import Betfair.APING.Types.ResponsePlaceOrders
import Betfair.APING.Types.RollupModel
import Betfair.APING.Types.Runner
import Betfair.APING.Types.RunnerCatalog
import Betfair.APING.Types.RunnerStatus
import Betfair.APING.Types.Side
import Betfair.APING.Types.StartingPrices
import Betfair.APING.Types.TimeRange
import Betfair.APING.Types.Token

type MarketId = Text

type SelectionId = Integer

type EventName = Text

type MarketName = Text

type RunnerName = Text

type PointId = Int

type Price = Double

type Size = Double
