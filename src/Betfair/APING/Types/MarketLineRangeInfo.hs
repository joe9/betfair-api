{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketLineRangeInfo
  ( MarketLineRangeInfo(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

import Text.PrettyPrint.GenericPretty

data MarketLineRangeInfo = MarketLineRangeInfo
  { maxUnitValue :: Double
  , minUnitValue :: Double
  , interval     :: Double
  , marketUnit   :: Text
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketLineRangeInfo)
