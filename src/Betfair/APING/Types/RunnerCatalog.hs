{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.RunnerCatalog
  (RunnerCatalog(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data RunnerCatalog =
  RunnerCatalog {selectionId  :: Integer
                ,runnerName   :: Text
                ,handicap     :: Double
                ,sortPriority :: Int
                ,metadata     :: Maybe [Text] -- [Runner_METADATA]
                }
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''RunnerCatalog)
