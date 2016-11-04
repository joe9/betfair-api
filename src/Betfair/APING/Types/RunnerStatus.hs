{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.RunnerStatus
  ( RunnerStatus(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data RunnerStatus
  = ACTIVE
  | WINNER
  | LOSER
  | REMOVED_VACANT
  | REMOVED
  | HIDDEN
  deriving (Eq, Show, Read, Enum)

$(deriveJSON defaultOptions {omitNothingFields = True} ''RunnerStatus)
