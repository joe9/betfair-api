{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderType
  ( OrderType(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data OrderType
  = LIMIT
  | LIMIT_ON_CLOSE
  | MARKET_ON_CLOSE
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''OrderType)
