{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketOnCloseOrder
  (MarketOnCloseOrder(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data MarketOnCloseOrder =
  MarketOnCloseOrder {liability :: Double}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketOnCloseOrder)
