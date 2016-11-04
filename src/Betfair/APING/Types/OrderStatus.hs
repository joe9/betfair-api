{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderStatus
  ( OrderStatus(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data OrderStatus
  = EXECUTION_COMPLETE
  | EXECUTABLE
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''OrderStatus)
