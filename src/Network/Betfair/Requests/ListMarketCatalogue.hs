{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.ListMarketCatalogue
  (listMarketCatalogue
  ,listMarketCatalogueResponseBodyString
  ,marketCatalogue
  ,jsonRequest
  ,JsonRequest(..)
  ,JsonParameters(..))
  where

import           Control.Monad.RWS                             (Monad (return, (>>)),
                                                                RWST,
                                                                (=<<))
import qualified Data.Aeson                                    as A (encode)
import           Data.Aeson.TH                                 (Options (omitNothingFields),
                                                                defaultOptions,
                                                                deriveJSON)
import           Data.Default                                  (Default (..))
import           Data.Either
import           Network.Betfair.Requests.APIRequest           (apiRequest)
import           Network.Betfair.Requests.GetResponse          (getResponseBody,
                                                                getResponseBodyString)
import           Network.Betfair.Requests.WriterLog            (Log, groomedLog)
import           Network.Betfair.Types.AppKey                  (AppKey)
import           Network.Betfair.Types.MarketBettingType       (MarketBettingType)
import           Network.Betfair.Types.MarketCatalogue         (MarketCatalogue)
import           Network.Betfair.Types.MarketFilter            (MarketFilter (marketBettingTypes, marketIds))
import           Network.Betfair.Types.MarketProjection        (MarketProjection (..))
import           Network.Betfair.Types.MarketSort              (MarketSort)
import           Network.Betfair.Types.ResponseMarketCatalogue (Response (result))
import           Network.Betfair.Types.Token                   (Token)
import Network.Betfair.Types.BettingException
import           Network.HTTP.Conduit                          (Manager)
import           Prelude                                       hiding
                                                                (Monad,
                                                                filter,
                                                                return,
                                                                (=<<),
                                                                (>>))

data JsonRequest =
  JsonRequest {jsonrpc :: String
              ,method  :: String
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
                 ,locale           :: Maybe String}
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

type MarketId = String

marketIdJsonRequest :: MarketId -> JsonParameters
marketIdJsonRequest mktid = def {filter = def {marketIds = Just [mktid]}}

marketCatalogue
  :: MarketId
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) [MarketCatalogue])
marketCatalogue mktid = listMarketCatalogue (marketIdJsonRequest mktid)

listMarketCatalogue
  :: JsonParameters
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) [MarketCatalogue])
listMarketCatalogue jp =
  groomedLog =<<
  fmap (either Left (Right . result)) . getResponseBody =<<
  (\r -> groomedLog (jsonRequest jp) >> return r) =<<
  apiRequest (A.encode $ jsonRequest jp)

listMarketCatalogueResponseBodyString
  :: JsonParameters -> RWST (AppKey,Token) Log Manager IO String
listMarketCatalogueResponseBodyString jp =
  getResponseBodyString =<< apiRequest (A.encode $ jsonRequest jp)
