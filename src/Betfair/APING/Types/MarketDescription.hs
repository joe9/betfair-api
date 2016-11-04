{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketDescription
  ( MarketDescription(..)
  ) where

import Betfair.APING.Types.MarketBettingType (MarketBettingType)
import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Protolude

type DateString = Text

data MarketDescription = MarketDescription
  { persistenceEnabled :: Bool
  , bspMarket          :: Bool
  , marketTime         :: DateString
  , suspendTime        :: DateString
  , settleTime         :: Maybe DateString
  , bettingType        :: MarketBettingType
  , turnInPlayEnabled  :: Bool
  , marketType         :: Text
  , regulator          :: Text
  , marketBaseRate     :: Double
  , discountAllowed    :: Bool
  , wallet             :: Maybe Text
  , rules              :: Maybe Text
  , rulesHasDate       :: Maybe Bool
  , eachWayDivisor     :: Maybe Double
  , clarifications     :: Maybe Text
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''MarketDescription)
