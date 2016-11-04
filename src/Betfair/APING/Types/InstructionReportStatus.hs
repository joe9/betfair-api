{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.InstructionReportStatus
  ( InstructionReportStatus(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data InstructionReportStatus
  = SUCCESS
  | FAILURE
  | TIMEOUT
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''InstructionReportStatus)
