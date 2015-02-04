{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.ExecutionReportStatus
   ( ExecutionReportStatus(..)
   ) where

import           Data.Aeson.TH   (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import           Data.Default.TH (deriveDefault)

data ExecutionReportStatus = SUCCESS
                           | FAILURE
                           | PROCESSED_WITH_ERRORS
                           | TIMEOUT
                           deriving (Eq, Show)

deriveDefault ''ExecutionReportStatus
$(deriveJSON defaultOptions {omitNothingFields = True} ''ExecutionReportStatus)
