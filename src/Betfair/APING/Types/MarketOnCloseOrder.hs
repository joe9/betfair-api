{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketOnCloseOrder
  ( MarketOnCloseOrder(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data MarketOnCloseOrder = MarketOnCloseOrder
  { liability :: Double
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketOnCloseOrder)
