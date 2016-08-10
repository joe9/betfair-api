{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceInstructionReport
  (PlaceInstructionReport(..))
  where

import BasicPrelude
import Data.Aeson.TH                                    (Options (omitNothingFields),
                                                         defaultOptions,
                                                         deriveJSON)
import Data.Default.TH                                  (deriveDefault)
import Betfair.APING.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Betfair.APING.Types.InstructionReportStatus    (InstructionReportStatus)
import Betfair.APING.Types.PlaceInstruction           (PlaceInstruction)

-- type DateString = Text
data PlaceInstructionReport =
  PlaceInstructionReport {status :: InstructionReportStatus
                         ,errorCode :: Maybe InstructionReportErrorCode
                         ,instruction :: PlaceInstruction
                         ,betId :: Maybe Text
                         ,placedDate :: Maybe Text -- DateString
                         ,averagePriceMatched :: Maybe Double
                         ,sizeMatched :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''PlaceInstructionReport

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PlaceInstructionReport)
