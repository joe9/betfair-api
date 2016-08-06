{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.InstructionReportStatus
  (InstructionReportStatus(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data InstructionReportStatus
  = SUCCESS
  | FAILURE
  | TIMEOUT
  deriving (Eq,Show)

deriveDefault ''InstructionReportStatus

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''InstructionReportStatus)
