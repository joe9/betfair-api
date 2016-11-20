{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.MarketCatalogue
  ( MarketCatalogue(..)
  ) where

import Betfair.APING.Types.Competition       (Competition)
import Betfair.APING.Types.Event             (Event)
import Betfair.APING.Types.EventType         (EventType)
import Betfair.APING.Types.MarketDescription (MarketDescription)
import Betfair.APING.Types.RunnerCatalog     (RunnerCatalog)
import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

type DateString = Text

data MarketCatalogue = MarketCatalogue
  { marketId        :: Text
  , marketName      :: Text
  , marketStartTime :: Maybe DateString
  , description     :: Maybe MarketDescription
  , totalMatched    :: Maybe Double
  , runners         :: Maybe [RunnerCatalog]
  , eventType       :: Maybe EventType
  , competition     :: Maybe Competition
  , event           :: Maybe Event
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketCatalogue)
