{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.ListMarketCatalogue
  (listMarketCatalogue
  ,marketCatalogue
  ,jsonRequest
  ,JsonRequest(..)
  ,JsonParameters(..))
  where

import           BasicPrelude                                hiding
                                                              (filter)
import qualified Data.Aeson                                  as A (encode)
import           Data.Aeson.TH                               (Options (omitNothingFields),
                                                              defaultOptions,
                                                              deriveJSON)
import           Data.Default                                (Default (..))
--
import           Betfair.APING.API.APIRequest                (apiRequest)
import           Betfair.APING.API.Context
import           Betfair.APING.API.GetResponse               (getDecodedResponse)
import           Betfair.APING.API.Log                       (groomedLog)
import           Betfair.APING.Types.MarketBettingType       (MarketBettingType)
import           Betfair.APING.Types.MarketCatalogue         (MarketCatalogue)
import           Betfair.APING.Types.MarketFilter            (MarketFilter (marketBettingTypes, marketIds))
import           Betfair.APING.Types.MarketProjection        (MarketProjection (..))
import           Betfair.APING.Types.MarketSort              (MarketSort)
import           Betfair.APING.Types.ResponseMarketCatalogue (Response (result))


data JsonRequest =
  JsonRequest {jsonrpc :: Text
              ,method  :: Text
              ,params  :: Maybe JsonParameters
              ,id      :: Int}
  deriving (Eq,Show)

instance Default JsonRequest where
  def =
    JsonRequest "2.0"
                "SportsAPING/v1.0/listMarketCatalogue"
                (Just def)
                1

data JsonParameters =
  JsonParameters {filter           :: MarketFilter
                 ,marketProjection :: Maybe [MarketProjection]
                 ,sort             :: MarketSort
                 ,maxResults       :: Int
                 ,locale           :: Maybe Text}
  deriving (Eq,Show)

-- deriveDefault ''JsonParameters
-- The weight of all the below are 0.
--   Hence, I should get the maximum of 1000 markets
instance Default JsonParameters where
  def =
    JsonParameters
      def
      (Just [COMPETITION
            ,EVENT
            ,EVENT_TYPE
            ,MARKET_START_TIME
            ,
             -- , MARKET_DESCRIPTION
             RUNNER_DESCRIPTION])
      -- , RUNNER_METADATA
      def
      1000
      def

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

type MarketId = Text

marketIdJsonRequest :: MarketId -> JsonParameters
marketIdJsonRequest mktid = def {filter = def {marketIds = Just [mktid]}}

marketCatalogue
  :: Context -> MarketId -> IO [MarketCatalogue]
marketCatalogue c mktid =
  listMarketCatalogue c
                      (marketIdJsonRequest mktid)

listMarketCatalogue
  :: Context
  -> JsonParameters
  -> IO [MarketCatalogue]
listMarketCatalogue c jp =
  groomedLog c =<<
  fmap result . getDecodedResponse c =<<
  (\r ->
     groomedLog c
                (jsonRequest jp) >>
     return r) =<<
  apiRequest c
             (A.encode $ jsonRequest jp)
