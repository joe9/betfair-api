{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExecutionReportStatus
  ( ExecutionReportStatus(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data ExecutionReportStatus
  = SUCCESS
  | FAILURE
  | PROCESSED_WITH_ERRORS
  | TIMEOUT
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''ExecutionReportStatus)
