{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketSort
  (MarketSort(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data MarketSort
  = FIRST_TO_START
  | MINIMUM_TRADED
  | MAXIMUM_TRADED
  | MINIMUM_AVAILABLE
  | MAXIMUM_AVAILABLE
  | LAST_TO_START
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketSort)
