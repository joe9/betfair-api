{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.RollupModel
  (RollupModel(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data RollupModel
  = NONE
  | STAKE
  | PAYOUT
  | MANAGED_LIABILITY
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''RollupModel)
