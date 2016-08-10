{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.ListMarketBook
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

import Betfair.APING.API.APIRequest      (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse     (getDecodedResponse)
import Betfair.APING.API.WriterLog
import Betfair.APING.API.ResponseException
import Betfair.APING.Types.MarketBook         (MarketBook)
import Betfair.APING.Types.MatchProjection    (MatchProjection)
import Betfair.APING.Types.OrderProjection    (OrderProjection)
import Betfair.APING.Types.PriceData          (PriceData)
import Betfair.APING.Types.PriceProjection    (PriceProjection (priceData))
import Betfair.APING.Types.ResponseMarketBook

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
  -> IO (Either ResponseException [MarketBook])
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
  -> IO (Either ResponseException [MarketBook])
marketBook c mktid pd =
  listMarketBook
    c
    (def {marketIds = [mktid]
         ,priceProjection = def {priceData = pd}})

marketBooks
  :: Context
  -> [MarketId]
  -> [PriceData]
  -> IO (Either ResponseException [MarketBook])
marketBooks c mktids pd =
  listMarketBook
    c
    (def {marketIds = mktids
         ,priceProjection = def {priceData = pd}})
