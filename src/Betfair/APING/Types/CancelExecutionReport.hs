{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelExecutionReport
  (CancelExecutionReport(..))
  where

import Protolude
import Betfair.APING.Types.CancelInstructionReport  (CancelInstructionReport)
import Betfair.APING.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Betfair.APING.Types.ExecutionReportStatus    (ExecutionReportStatus)
import Data.Aeson.TH                                (Options (omitNothingFields),
                                                     defaultOptions,
                                                     deriveJSON)

data CancelExecutionReport =
  CancelExecutionReport {customerRef :: Maybe Text
                        ,status :: ExecutionReportStatus
                        ,errorCode :: Maybe ExecutionReportErrorCode
                        ,marketId :: Maybe Text
                        ,instructionReports :: Maybe [CancelInstructionReport]}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelExecutionReport)
