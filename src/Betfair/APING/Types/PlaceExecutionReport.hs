{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceExecutionReport
  ( PlaceExecutionReport(..)
  ) where

import Betfair.APING.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Betfair.APING.Types.ExecutionReportStatus    (ExecutionReportStatus)
import Betfair.APING.Types.PlaceInstructionReport   (PlaceInstructionReport)
import Data.Aeson.TH                                (Options (omitNothingFields),
                                                     defaultOptions,
                                                     deriveJSON)
import Protolude

data PlaceExecutionReport = PlaceExecutionReport
  { customerRef        :: Maybe Text
  , status             :: ExecutionReportStatus
  , errorCode          :: Maybe ExecutionReportErrorCode
  , marketId           :: Maybe Text
  , instructionReports :: Maybe [PlaceInstructionReport]
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''PlaceExecutionReport)
