{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PlaceInstructionReport
  ( PlaceInstructionReport(..)
  ) where

import Betfair.APING.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Betfair.APING.Types.InstructionReportStatus    (InstructionReportStatus)
import Betfair.APING.Types.PlaceInstruction           (PlaceInstruction)
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Protolude

-- type DateString = Text
data PlaceInstructionReport = PlaceInstructionReport
  { status              :: InstructionReportStatus
  , errorCode           :: Maybe InstructionReportErrorCode
  , instruction         :: PlaceInstruction
  , betId               :: Maybe Text
  , placedDate          :: Maybe Text -- DateString
  , averagePriceMatched :: Maybe Double
  , sizeMatched         :: Maybe Double
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''PlaceInstructionReport)
