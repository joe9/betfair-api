{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.InstructionReportStatus
  (InstructionReportStatus(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data InstructionReportStatus
  = SUCCESS
  | FAILURE
  | TIMEOUT
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''InstructionReportStatus)
