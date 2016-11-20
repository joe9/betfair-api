{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstructionReport
  ( CancelInstructionReport(..)
  ) where

import Betfair.APING.Types.CancelInstruction          (CancelInstruction)
import Betfair.APING.Types.InstructionReportErrorCode (InstructionReportErrorCode)
import Betfair.APING.Types.InstructionReportStatus    (InstructionReportStatus)
import Data.Aeson.TH                                  (Options (omitNothingFields),
                                                       defaultOptions,
                                                       deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

-- type DateString = Text
data CancelInstructionReport = CancelInstructionReport
  { status        :: InstructionReportStatus
  , errorCode     :: Maybe InstructionReportErrorCode
  , instruction   :: Maybe CancelInstruction
  , sizeCancelled :: Double
  , cancelledDate :: Maybe Text -- DateString
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''CancelInstructionReport)
