{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketOnCloseOrder
  (MarketOnCloseOrder(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data MarketOnCloseOrder =
  MarketOnCloseOrder {liability :: Double}
  deriving (Eq,Show)

deriveDefault ''MarketOnCloseOrder

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketOnCloseOrder)
