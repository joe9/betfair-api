{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.RunnerCatalog
  (RunnerCatalog(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data RunnerCatalog =
  RunnerCatalog {selectionId  :: Integer
                ,runnerName   :: Text
                ,handicap     :: Double
                ,sortPriority :: Int
                ,metadata     :: Maybe [Text] -- [Runner_METADATA]
                }
  deriving (Eq,Show)

deriveDefault ''RunnerCatalog

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''RunnerCatalog)
