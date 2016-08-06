{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.ListMarketBook
  (JsonParameters(..)
  ,listMarketBook
  ,marketBook
  ,marketBooks
  ,JsonRequest(..))
  where

import           BasicPrelude
import qualified Data.Aeson    as A (encode)
import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)
import           Data.Default  (Default (..))

import Network.Betfair.Requests.APIRequest      (apiRequest)
import Network.Betfair.Requests.Context
import Network.Betfair.Requests.GetResponse     (getDecodedResponse)
import Network.Betfair.Requests.WriterLog
import Network.Betfair.Types.BettingException
import Network.Betfair.Types.MarketBook         (MarketBook)
import Network.Betfair.Types.MatchProjection    (MatchProjection)
import Network.Betfair.Types.OrderProjection    (OrderProjection)
import Network.Betfair.Types.PriceData          (PriceData)
import Network.Betfair.Types.PriceProjection    (PriceProjection (priceData))
import Network.Betfair.Types.ResponseMarketBook

data JsonRequest =
  JsonRequest {jsonrpc :: Text
              ,method  :: Text
              ,params  :: Maybe JsonParameters
              ,id      :: Int}
  deriving (Eq,Show)

instance Default JsonRequest where
  def =
    JsonRequest "2.0"
                "SportsAPING/v1.0/listMarketBook"
                (Just def)
                1

data JsonParameters =
  JsonParameters {marketIds       :: [Text]
                 ,priceProjection :: PriceProjection
                 ,orderProjection :: OrderProjection
                 ,matchProjection :: MatchProjection
                 ,currencyCode    :: Text
                 ,locale          :: Maybe Text}
  deriving (Eq,Show)

-- deriveDefault ''JsonParameters
instance Default JsonParameters where
  def = JsonParameters def def def def "GBP" def

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

listMarketBook
  :: Context
  -> JsonParameters
  -> IO (Either (Either Text BettingException) [MarketBook])
listMarketBook c jp =
  do groomedLog c =<<
       fmap (either Left (Right . result)) . getDecodedResponse c =<<
       (\r ->
          groomedLog c
                     (jsonRequest jp) >>
          return r) =<<
       apiRequest c
                  (A.encode $ jsonRequest jp)

type MarketId = Text

marketBook
  :: Context
  -> MarketId
  -> [PriceData]
  -> IO (Either (Either Text BettingException) [MarketBook])
marketBook c mktid pd =
  listMarketBook
    c
    (def {marketIds = [mktid]
         ,priceProjection = def {priceData = pd}})

marketBooks
  :: Context
  -> [MarketId]
  -> [PriceData]
  -> IO (Either (Either Text BettingException) [MarketBook])
marketBooks c mktids pd =
  listMarketBook
    c
    (def {marketIds = mktids
         ,priceProjection = def {priceData = pd}})
