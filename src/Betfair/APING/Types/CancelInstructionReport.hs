{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstructionReport
  (CancelInstructionReport(..))
  where

import Protolude
import Betfair.APING.Types.CancelInstruction          (CancelInstruction)
import Betfair.APING.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Betfair.APING.Types.InstructionReportStatus    (InstructionReportStatus)
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)

-- type DateString = Text
data CancelInstructionReport =
  CancelInstructionReport {status :: InstructionReportStatus
                          ,errorCode :: Maybe InstructionReportErrorCode
                          ,instruction :: Maybe CancelInstruction
                          ,sizeCancelled :: Double
                          ,cancelledDate :: Maybe Text -- DateString
                          }
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstructionReport)
