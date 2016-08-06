{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.CancelInstructionReport
  (CancelInstructionReport(..))
  where

import Data.Aeson.TH                                    (Options (omitNothingFields),
                                                         defaultOptions,
                                                         deriveJSON)
import Data.Default.TH                                  (deriveDefault)
import Network.Betfair.Types.CancelInstruction          (CancelInstruction)
import Network.Betfair.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Network.Betfair.Types.InstructionReportStatus    (InstructionReportStatus)

-- type DateString = String
data CancelInstructionReport =
  CancelInstructionReport {status :: InstructionReportStatus
                          ,errorCode :: Maybe InstructionReportErrorCode
                          ,instruction :: Maybe CancelInstruction
                          ,sizeCancelled :: Double
                          ,cancelledDate :: Maybe String -- DateString
                          }
  deriving (Eq,Show)

deriveDefault ''CancelInstructionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstructionReport)
