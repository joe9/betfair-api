{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.PlaceInstructionReport
  (PlaceInstructionReport(..))
  where

import Data.Aeson.TH                                    (Options (omitNothingFields),
                                                         defaultOptions,
                                                         deriveJSON)
import Data.Default.TH                                  (deriveDefault)
import Network.Betfair.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Network.Betfair.Types.InstructionReportStatus    (InstructionReportStatus)
import Network.Betfair.Types.PlaceInstruction           (PlaceInstruction)

-- type DateString = String
data PlaceInstructionReport =
  PlaceInstructionReport {status :: InstructionReportStatus
                         ,errorCode :: Maybe InstructionReportErrorCode
                         ,instruction :: PlaceInstruction
                         ,betId :: Maybe String
                         ,placedDate :: Maybe String -- DateString
                         ,averagePriceMatched :: Maybe Double
                         ,sizeMatched :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''PlaceInstructionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PlaceInstructionReport)
