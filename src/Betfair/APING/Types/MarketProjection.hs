{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall      #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketProjection
  (MarketProjection(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data MarketProjection
  = COMPETITION
  | EVENT
  | EVENT_TYPE
  | MARKET_START_TIME
  | MARKET_DESCRIPTION
  | RUNNER_DESCRIPTION
  | RUNNER_METADATA
  deriving (Eq,Show)

deriveDefault ''MarketProjection

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketProjection)
