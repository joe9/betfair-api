{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.CancelExecutionReport
  (CancelExecutionReport(..))
  where

import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Data.Default.TH                                (deriveDefault)
import Network.Betfair.Types.CancelInstructionReport  (CancelInstructionReport)
import Network.Betfair.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Network.Betfair.Types.ExecutionReportStatus    (ExecutionReportStatus)

data CancelExecutionReport =
  CancelExecutionReport {customerRef :: Maybe String
                        ,status :: ExecutionReportStatus
                        ,errorCode :: Maybe ExecutionReportErrorCode
                        ,marketId :: Maybe String
                        ,instructionReports :: Maybe [CancelInstructionReport]}
  deriving (Eq,Show)

deriveDefault ''CancelExecutionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelExecutionReport)
