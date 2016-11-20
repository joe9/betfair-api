{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.RunnerStatus
  ( RunnerStatus(..)
  ) where

import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data RunnerStatus
  = ACTIVE
  | WINNER
  | LOSER
  | REMOVED_VACANT
  | REMOVED
  | HIDDEN
  deriving (Eq, Show, Generic, Pretty, Read, Enum)

$(deriveJSON defaultOptions {omitNothingFields = True} ''RunnerStatus)
