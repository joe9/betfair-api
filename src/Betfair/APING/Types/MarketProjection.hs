{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketProjection
  ( MarketProjection(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data MarketProjection
  = COMPETITION
  | EVENT
  | EVENT_TYPE
  | MARKET_START_TIME
  | MARKET_DESCRIPTION
  | RUNNER_DESCRIPTION
  | RUNNER_METADATA
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketProjection)
