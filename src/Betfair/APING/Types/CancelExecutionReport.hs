{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelExecutionReport
  ( CancelExecutionReport(..)
  ) where

import Betfair.APING.Types.CancelInstructionReport  (CancelInstructionReport)
import Betfair.APING.Types.ExecutionReportErrorCode (ExecutionReportErrorCode)
import Betfair.APING.Types.ExecutionReportStatus    (ExecutionReportStatus)
import Data.Aeson.TH                                (Options (omitNothingFields),
                                                     defaultOptions,
                                                     deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data CancelExecutionReport = CancelExecutionReport
  { customerRef        :: Maybe Text
  , status             :: ExecutionReportStatus
  , errorCode          :: Maybe ExecutionReportErrorCode
  , marketId           :: Maybe Text
  , instructionReports :: Maybe [CancelInstructionReport]
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''CancelExecutionReport)
