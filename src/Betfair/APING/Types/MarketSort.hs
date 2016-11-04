{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketSort
  ( MarketSort(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data MarketSort
  = FIRST_TO_START
  | MINIMUM_TRADED
  | MAXIMUM_TRADED
  | MINIMUM_AVAILABLE
  | MAXIMUM_AVAILABLE
  | LAST_TO_START
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketSort)
