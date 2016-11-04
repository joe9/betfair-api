{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketBook
  (MarketBook(..))
  where

import Protolude
import Betfair.APING.Types.MarketStatus (MarketStatus)
import Betfair.APING.Types.Runner       (Runner)
import Data.Aeson.TH                    (Options (omitNothingFields),
                                         defaultOptions, deriveJSON)

type DateString = Text

data MarketBook =
  MarketBook {marketId              :: Text
             ,isMarketDataDelayed   :: Bool
             ,status                :: Maybe MarketStatus
             ,betDelay              :: Maybe Int
             ,bspReconciled         :: Maybe Bool
             ,complete              :: Maybe Bool
             ,inplay                :: Maybe Bool
             ,numberOfWinners       :: Maybe Int
             ,numberOfRunners       :: Maybe Int
             ,numberOfActiveRunners :: Maybe Int
             ,lastMatchTime         :: Maybe DateString
             ,totalMatched          :: Maybe Double
             ,totalAvailable        :: Maybe Double
             ,crossMatching         :: Maybe Bool
             ,runnersVoidable       :: Maybe Bool
             ,version               :: Maybe Integer
             ,runners               :: Maybe [Runner]}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketBook)
