{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketBettingType
  (MarketBettingType(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data MarketBettingType
  = ODDS
  | LINE
  | RANGE
  | ASIAN_HANDICAP_DOUBLE_LINE
  | ASIAN_HANDICAP_SINGLE_LINE
  | FIXED_ODDS
  deriving (Eq,Show)

deriveDefault ''MarketBettingType

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketBettingType)
