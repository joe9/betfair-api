{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.RollupModel
  ( RollupModel(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data RollupModel
  = NONE
  | STAKE
  | PAYOUT
  | MANAGED_LIABILITY
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''RollupModel)
