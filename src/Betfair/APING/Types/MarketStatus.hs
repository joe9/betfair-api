{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketStatus
  ( MarketStatus(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data MarketStatus
  = INACTIVE
  | OPEN
  | SUSPENDED
  | CLOSED
  deriving (Eq, Show, Read, Enum)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketStatus)
