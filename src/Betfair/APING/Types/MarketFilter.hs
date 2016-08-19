{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall       #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketFilter
  (MarketFilter(..))
  where

import BasicPrelude
import Betfair.APING.Types.MarketBettingType (MarketBettingType)
import Betfair.APING.Types.OrderStatus       (OrderStatus)
import Betfair.APING.Types.TimeRange         (TimeRange)
import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Data.Default.TH                       (deriveDefault)

data MarketFilter =
  MarketFilter {textQuery          :: Maybe Text
               ,exchangeIds        :: Maybe [Text]
               ,eventTypeIds       :: Maybe [Text]
               ,eventIds           :: Maybe [Text]
               ,competitionIds     :: Maybe [Text]
               ,marketIds          :: Maybe [Text]
               ,venues             :: Maybe [Text]
               ,bspOnly            :: Maybe Bool
               ,turnInPlayEnabled  :: Maybe Bool
               ,inPlayOnly         :: Maybe Bool
               ,marketBettingTypes :: [MarketBettingType]
               ,marketCountries    :: Maybe [Text]
               ,marketTypeCodes    :: Maybe [Text]
               ,marketStartTime    :: Maybe TimeRange
               ,withOrders         :: Maybe [OrderStatus]}
  deriving (Eq,Show)

-- this is what deriveDefault does anyway
-- instance Default MarketSort where def = FIRST_TO_START
-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketFilter)

deriveDefault ''MarketFilter
