{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Network.Betfair.Types.RunnerStatus
   ( RunnerStatus(..)
   ) where

import           Data.Aeson.TH   (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import           Data.Default.TH (deriveDefault)

data RunnerStatus = ACTIVE
                      | WINNER
                      | LOSER
                      | REMOVED_VACANT
                      | REMOVED
                      | HIDDEN
   deriving (Eq, Show)

deriveDefault ''RunnerStatus
$(deriveJSON defaultOptions {omitNothingFields = True} ''RunnerStatus)
