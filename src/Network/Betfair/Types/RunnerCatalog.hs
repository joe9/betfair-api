{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.RunnerCatalog
  (RunnerCatalog(..))
  where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data RunnerCatalog =
  RunnerCatalog {selectionId  :: Integer
                ,runnerName   :: String
                ,handicap     :: Double
                ,sortPriority :: Int
                ,metadata     :: Maybe [String] -- [Runner_METADATA]
                }
  deriving (Eq,Show)

deriveDefault ''RunnerCatalog

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''RunnerCatalog)
