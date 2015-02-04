{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.MarketDescription
   ( MarketDescription(..)
   ) where

import           Data.Aeson.TH                           (Options (omitNothingFields), defaultOptions,
                                                          deriveJSON)

import           Network.Betfair.Types.MarketBettingType (MarketBettingType)

type DateString = String

data MarketDescription = MarketDescription
   { persistenceEnabled :: Bool
   , bspMarket          :: Bool
   , marketTime         :: DateString
   , suspendTime        :: DateString
   , settleTime         :: Maybe DateString
   , bettingType        :: MarketBettingType
   , turnInPlayEnabled  :: Bool
   , marketType         :: String
   , regulator          :: String
   , marketBaseRate     :: Double
   , discountAllowed    :: Bool
   , wallet             :: Maybe String
   , rules              :: Maybe String
   , rulesHasDate       :: Maybe Bool
   , clarifications     :: Maybe String
   } deriving (Eq, Show)

-- deriveDefault ''MarketDescription
$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketDescription)
