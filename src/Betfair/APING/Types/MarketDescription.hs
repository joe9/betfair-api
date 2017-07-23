{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketDescription
  ( MarketDescription(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

import Text.PrettyPrint.GenericPretty

import Betfair.APING.Types.MarketBettingType      (MarketBettingType)
import Betfair.APING.Types.MarketLineRangeInfo    (MarketLineRangeInfo)
import Betfair.APING.Types.PriceLadderDescription (PriceLadderDescription)

type DateString = Text

data MarketDescription = MarketDescription
  { persistenceEnabled     :: Bool
  , bspMarket              :: Bool
  , marketTime             :: DateString
  , suspendTime            :: DateString
  , settleTime             :: Maybe DateString
  , bettingType            :: MarketBettingType
  , turnInPlayEnabled      :: Bool
  , marketType             :: Text
  , regulator              :: Text
  , marketBaseRate         :: Double
  , discountAllowed        :: Bool
  , wallet                 :: Maybe Text
  , rules                  :: Maybe Text
  , rulesHasDate           :: Maybe Bool
  , eachWayDivisor         :: Maybe Double
  , clarifications         :: Maybe Text
  , lineRangeInfo          :: Maybe MarketLineRangeInfo
  , priceLadderDescription :: Maybe PriceLadderDescription
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketDescription)
