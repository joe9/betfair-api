{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Match
  ( Match(..)
  ) where

import Betfair.APING.Types.Side (Side)
import Data.Aeson.TH            (Options (omitNothingFields),
                                 defaultOptions, deriveJSON)
import Protolude

type DateString = Text

data Match = Match
  { betId     :: Maybe Text
  , matchId   :: Maybe Text
  , side      :: Side
  , price     :: Double
  , size      :: Double
  , matchDate :: Maybe DateString
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Match)
