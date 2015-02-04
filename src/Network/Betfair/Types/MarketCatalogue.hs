{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell #-}

module Network.Betfair.Types.MarketCatalogue
   ( MarketCatalogue(..)
   ) where

import           Data.Aeson.TH                           (Options (omitNothingFields), defaultOptions,
                                                          deriveJSON)

import           Network.Betfair.Types.Competition       (Competition)
import           Network.Betfair.Types.Event             (Event)
import           Network.Betfair.Types.EventType         (EventType)
import           Network.Betfair.Types.MarketDescription (MarketDescription)
import           Network.Betfair.Types.RunnerCatalog     (RunnerCatalog)

type DateString = String

data MarketCatalogue = MarketCatalogue
   { marketId        :: String
   , marketName      :: String
   , marketStartTime :: Maybe DateString
   , description     :: Maybe MarketDescription
   , totalMatched    :: Maybe Double
   , runners         :: Maybe [RunnerCatalog]
   , eventType       :: Maybe EventType
   , competition     :: Maybe Competition
   , event           :: Maybe Event
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketCatalogue)
