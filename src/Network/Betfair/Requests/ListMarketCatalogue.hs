{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.ListMarketCatalogue
  (listMarketCatalogue
  ,marketCatalogue
  ,jsonRequest
  ,JsonRequest(..)
  ,JsonParameters(..))
  where

import           BasicPrelude  hiding (filter)
import qualified Data.Aeson    as A (encode)
import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)
import           Data.Default  (Default (..))

import Network.Betfair.Requests.APIRequest           (apiRequest)
import Network.Betfair.Requests.Context
import Network.Betfair.Requests.GetResponse          (getDecodedResponse)
import Network.Betfair.Requests.WriterLog            (groomedLog)
import Network.Betfair.Requests.ResponseException
import Network.Betfair.Types.MarketBettingType       (MarketBettingType)
import Network.Betfair.Types.MarketCatalogue         (MarketCatalogue)
import Network.Betfair.Types.MarketFilter            (MarketFilter (marketBettingTypes, marketIds))
import Network.Betfair.Types.MarketProjection        (MarketProjection (..))
import Network.Betfair.Types.MarketSort              (MarketSort)
import Network.Betfair.Types.ResponseMarketCatalogue (Response (result))

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
      (def {marketBettingTypes = [def :: MarketBettingType]})
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
  :: Context
  -> MarketId
  -> IO (Either ResponseException [MarketCatalogue])
marketCatalogue c mktid =
  listMarketCatalogue c
                      (marketIdJsonRequest mktid)

listMarketCatalogue
  :: Context
  -> JsonParameters
  -> IO (Either ResponseException [MarketCatalogue])
listMarketCatalogue c jp =
  groomedLog c =<<
  fmap (either Left (Right . result)) . getDecodedResponse c =<<
  (\r ->
     groomedLog c
                (jsonRequest jp) >>
     return r) =<<
  apiRequest c
             (A.encode $ jsonRequest jp)
