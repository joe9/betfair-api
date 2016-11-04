{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExecutionReportStatus
  (ExecutionReportStatus(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data ExecutionReportStatus
  = SUCCESS
  | FAILURE
  | PROCESSED_WITH_ERRORS
  | TIMEOUT
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExecutionReportStatus)
