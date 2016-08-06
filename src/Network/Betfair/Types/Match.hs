{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Match
  (Match(..))
  where

import Data.Aeson.TH              (Options (omitNothingFields),
                                   defaultOptions, deriveJSON)
import Network.Betfair.Types.Side (Side)

type DateString = String

data Match =
  Match {betId     :: Maybe String
        ,matchId   :: Maybe String
        ,side      :: Side
        ,price     :: Double
        ,size      :: Double
        ,matchDate :: Maybe DateString}
  deriving (Eq,Show)

-- deriveDefault ''Match
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Match)
