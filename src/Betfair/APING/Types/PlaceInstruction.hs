{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceInstruction
  (PlaceInstruction(..))
  where

import BasicPrelude
import Data.Aeson.TH                            (Options (omitNothingFields),
                                                 defaultOptions,
                                                 deriveJSON)
import Data.Default.TH                          (deriveDefault)
import Betfair.APING.Types.LimitOnCloseOrder  (LimitOnCloseOrder)
import Betfair.APING.Types.LimitOrder         (LimitOrder)
import Betfair.APING.Types.MarketOnCloseOrder (MarketOnCloseOrder)
import Betfair.APING.Types.OrderType          (OrderType)
import Betfair.APING.Types.Side               (Side)

data PlaceInstruction =
  PlaceInstruction {orderType          :: OrderType
                   ,selectionId        :: Integer
                   ,handicap           :: Maybe Double
                   ,side               :: Side
                   ,limitOrder         :: Maybe LimitOrder
                   ,limitOnCloseOrder  :: Maybe LimitOnCloseOrder
                   ,marketOnCloseOrder :: Maybe MarketOnCloseOrder}
  deriving (Eq,Show)

deriveDefault ''PlaceInstruction

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PlaceInstruction)
