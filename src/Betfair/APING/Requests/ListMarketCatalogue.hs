{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.ListMarketCatalogue
  ( listMarketCatalogue
  , marketCatalogue
  , jsonRequest
  , JsonRequest(..)
  , JsonParameters(..)
  , defaultJsonParameters
  ) where

import qualified Data.Aeson                     as A (encode)
import           Data.Aeson.TH                  (Options (omitNothingFields),
                                                 defaultOptions,
                                                 deriveJSON)
import           Protolude                      hiding (filter)
import           Text.PrettyPrint.GenericPretty

--
import Betfair.APING.API.APIRequest                (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse               (getDecodedResponse)
import Betfair.APING.API.Log                       (tracePPLog)
import Betfair.APING.Types.MarketCatalogue         (MarketCatalogue)
import Betfair.APING.Types.MarketFilter            (MarketFilter (marketIds),
                                                    defaultMarketFilter)
import Betfair.APING.Types.MarketProjection        (MarketProjection (..))
import Betfair.APING.Types.MarketSort              (MarketSort (FIRST_TO_START))
import Betfair.APING.Types.ResponseMarketCatalogue (Response (result))

data JsonRequest = JsonRequest
  { jsonrpc :: Text
  , method  :: Text
  , params  :: Maybe JsonParameters
  , id      :: Int
  } deriving (Eq, Show, Generic, Pretty)

data JsonParameters = JsonParameters
  { filter           :: MarketFilter
  , marketProjection :: Maybe [MarketProjection]
  , sort             :: MarketSort
  , maxResults       :: Int
  , locale           :: Maybe Text
  } deriving (Eq, Show, Generic, Pretty)

-- The weight of all the below are 0.
--   Hence, I should get the maximum of 1000 markets
defaultJsonParameters :: JsonParameters
defaultJsonParameters =
  JsonParameters
    defaultMarketFilter
    (Just
       [ COMPETITION
       , EVENT
       , EVENT_TYPE
       , MARKET_START_TIME
         -- , MARKET_DESCRIPTION
       , RUNNER_DESCRIPTION
       ])
    -- , RUNNER_METADATA
    FIRST_TO_START
    1000
    Nothing

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp =
  JsonRequest "2.0" "SportsAPING/v1.0/listMarketCatalogue" (Just jp) 1

type MarketId = Text

marketIdJsonRequest :: MarketId -> JsonParameters
marketIdJsonRequest mktid =
  defaultJsonParameters
  {filter = defaultMarketFilter {marketIds = Just [mktid]}}

marketCatalogue :: Context -> MarketId -> IO [MarketCatalogue]
marketCatalogue c mktid = listMarketCatalogue c (marketIdJsonRequest mktid)

listMarketCatalogue :: Context -> JsonParameters -> IO [MarketCatalogue]
listMarketCatalogue c jp =
  tracePPLog c =<<
  fmap result . getDecodedResponse c =<<
  (\r -> tracePPLog c (jsonRequest jp) >> return r) =<<
  apiRequest c (A.encode $ jsonRequest jp)
