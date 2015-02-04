{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.PlaceInstruction
   ( PlaceInstruction(..)
   ) where

import           Data.Aeson.TH                            (Options (omitNothingFields), defaultOptions,
                                                           deriveJSON)
import           Data.Default.TH                          (deriveDefault)

import           Network.Betfair.Types.LimitOnCloseOrder  (LimitOnCloseOrder)
import           Network.Betfair.Types.LimitOrder         (LimitOrder)
import           Network.Betfair.Types.MarketOnCloseOrder (MarketOnCloseOrder)
import           Network.Betfair.Types.OrderType          (OrderType)
import           Network.Betfair.Types.Side               (Side)

data PlaceInstruction = PlaceInstruction
   { orderType          :: OrderType
   , selectionId        :: Integer
   , handicap           :: Maybe Double
   , side               :: Side
   , limitOrder         :: Maybe LimitOrder
   , limitOnCloseOrder  :: Maybe LimitOnCloseOrder
   , marketOnCloseOrder :: Maybe MarketOnCloseOrder
   } deriving (Eq, Show)

deriveDefault ''PlaceInstruction
$(deriveJSON defaultOptions {omitNothingFields = True} ''PlaceInstruction)
