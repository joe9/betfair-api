{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.MarketBook
   ( MarketBook(..)
   ) where

import           Data.Aeson.TH                      (Options (omitNothingFields),
                                                     defaultOptions,
                                                     deriveJSON)
import           Data.Default.TH                    (deriveDefault)

import           Network.Betfair.Types.MarketStatus (MarketStatus)
import           Network.Betfair.Types.Runner       (Runner)

type DateString = String

data MarketBook = MarketBook
   { marketId              :: String
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
   } deriving (Eq, Show)

deriveDefault ''MarketBook
$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketBook)
