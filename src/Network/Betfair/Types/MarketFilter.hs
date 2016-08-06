{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.MarketFilter
  (MarketFilter(..))
  where

import BasicPrelude
import Data.Aeson.TH                           (Options (omitNothingFields),
                                                defaultOptions,
                                                deriveJSON)
import Data.Default.TH                         (deriveDefault)
import Network.Betfair.Types.MarketBettingType (MarketBettingType)
import Network.Betfair.Types.OrderStatus       (OrderStatus)
import Network.Betfair.Types.TimeRange         (TimeRange)

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
