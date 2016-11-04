{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.RunnerCatalog
  ( RunnerCatalog(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data RunnerCatalog = RunnerCatalog
  { selectionId  :: Integer
  , runnerName   :: Text
  , handicap     :: Double
  , sortPriority :: Int
  , metadata     :: Maybe [Text] -- [Runner_METADATA]
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''RunnerCatalog)
