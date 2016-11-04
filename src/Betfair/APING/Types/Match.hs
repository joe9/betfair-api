{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Match
  (Match(..))
  where

import Protolude
import Betfair.APING.Types.Side (Side)
import Data.Aeson.TH            (Options (omitNothingFields),
                                 defaultOptions, deriveJSON)

type DateString = Text

data Match =
  Match {betId     :: Maybe Text
        ,matchId   :: Maybe Text
        ,side      :: Side
        ,price     :: Double
        ,size      :: Double
        ,matchDate :: Maybe DateString}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Match)
