{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall       #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstructionReport
  (CancelInstructionReport(..))
  where

import BasicPrelude
import Betfair.APING.Types.CancelInstruction          (CancelInstruction)
import Betfair.APING.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Betfair.APING.Types.InstructionReportStatus    (InstructionReportStatus)
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Data.Default.TH                                (deriveDefault)

-- type DateString = Text
data CancelInstructionReport =
  CancelInstructionReport {status :: InstructionReportStatus
                          ,errorCode :: Maybe InstructionReportErrorCode
                          ,instruction :: Maybe CancelInstruction
                          ,sizeCancelled :: Double
                          ,cancelledDate :: Maybe Text -- DateString
                          }
  deriving (Eq,Show)

deriveDefault ''CancelInstructionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstructionReport)
