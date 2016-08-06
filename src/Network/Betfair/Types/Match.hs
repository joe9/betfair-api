{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Match
  (Match(..))
  where

import BasicPrelude
import Data.Aeson.TH              (Options (omitNothingFields),
                                   defaultOptions, deriveJSON)
import Network.Betfair.Types.Side (Side)

type DateString = Text

data Match =
  Match {betId     :: Maybe Text
        ,matchId   :: Maybe Text
        ,side      :: Side
        ,price     :: Double
        ,size      :: Double
        ,matchDate :: Maybe DateString}
  deriving (Eq,Show)

-- deriveDefault ''Match
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Match)
