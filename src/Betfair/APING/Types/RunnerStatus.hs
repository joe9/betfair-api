{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.RunnerStatus
  (RunnerStatus(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data RunnerStatus
  = ACTIVE
  | WINNER
  | LOSER
  | REMOVED_VACANT
  | REMOVED
  | HIDDEN
  deriving (Eq,Show,Read)

deriveDefault ''RunnerStatus

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''RunnerStatus)
