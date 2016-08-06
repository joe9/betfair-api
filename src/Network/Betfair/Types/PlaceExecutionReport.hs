{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.PlaceExecutionReport
  (PlaceExecutionReport(..))
  where

import BasicPrelude
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Data.Default.TH                                (deriveDefault)
import Network.Betfair.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Network.Betfair.Types.ExecutionReportStatus    (ExecutionReportStatus)
import Network.Betfair.Types.PlaceInstructionReport   (PlaceInstructionReport)

data PlaceExecutionReport =
  PlaceExecutionReport {customerRef :: Maybe Text
                       ,status :: ExecutionReportStatus
                       ,errorCode :: Maybe ExecutionReportErrorCode
                       ,marketId :: Maybe Text
                       ,instructionReports :: Maybe [PlaceInstructionReport]}
  deriving (Eq,Show)

deriveDefault ''PlaceExecutionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PlaceExecutionReport)
