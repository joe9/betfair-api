{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceExecutionReport
  (PlaceExecutionReport(..))
  where

import BasicPrelude
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Data.Default.TH                                (deriveDefault)
import Betfair.APING.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Betfair.APING.Types.ExecutionReportStatus    (ExecutionReportStatus)
import Betfair.APING.Types.PlaceInstructionReport   (PlaceInstructionReport)

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
