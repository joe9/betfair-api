{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketBook
  ( MarketBook(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

import Text.PrettyPrint.GenericPretty

import Betfair.APING.Types.KeyLineDescription (KeyLineDescription)
import Betfair.APING.Types.MarketStatus       (MarketStatus)
import Betfair.APING.Types.Runner             (Runner)

type DateString = Text

data MarketBook = MarketBook
  { marketId              :: Text
  , isMarketDataDelayed   :: Bool
  , status                :: Maybe MarketStatus
  , betDelay              :: Maybe Int
  , bspReconciled         :: Maybe Bool
  , complete              :: Maybe Bool
  , inplay                :: Maybe Bool
  , numberOfWinners       :: Maybe Int
  , numberOfRunners       :: Maybe Int
  , numberOfActiveRunners :: Maybe Int
  , lastMatchTime         :: Maybe DateString
  , totalMatched          :: Maybe Double
  , totalAvailable        :: Maybe Double
  , crossMatching         :: Maybe Bool
  , runnersVoidable       :: Maybe Bool
  , version               :: Maybe Integer
  , runners               :: Maybe [Runner]
  , keyLineDescription    :: Maybe KeyLineDescription
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketBook)
