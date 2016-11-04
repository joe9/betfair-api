{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceInstruction
  ( PlaceInstruction(..)
  ) where

import Betfair.APING.Types.LimitOnCloseOrder  (LimitOnCloseOrder)
import Betfair.APING.Types.LimitOrder         (LimitOrder)
import Betfair.APING.Types.MarketOnCloseOrder (MarketOnCloseOrder)
import Betfair.APING.Types.OrderType          (OrderType)
import Betfair.APING.Types.Side               (Side)
import Data.Aeson.TH                          (Options (omitNothingFields),
                                               defaultOptions,
                                               deriveJSON)
import Protolude

data PlaceInstruction = PlaceInstruction
  { orderType          :: OrderType
  , selectionId        :: Integer
  , handicap           :: Maybe Double
  , side               :: Side
  , limitOrder         :: Maybe LimitOrder
  , limitOnCloseOrder  :: Maybe LimitOnCloseOrder
  , marketOnCloseOrder :: Maybe MarketOnCloseOrder
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''PlaceInstruction)
