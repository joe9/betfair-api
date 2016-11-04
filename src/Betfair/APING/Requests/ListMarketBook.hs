{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.ListMarketBook
  ( JsonParameters(..)
  , listMarketBook
  , marketBook
  , marketBooks
  , JsonRequest(..)
  ) where

import qualified Data.Aeson    as A (encode)
import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)
import           Protolude

--
import Betfair.APING.API.APIRequest           (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse          (getDecodedResponse)
import Betfair.APING.API.Log
import Betfair.APING.Types.MarketBook         (MarketBook)
import Betfair.APING.Types.MatchProjection    (MatchProjection (NO_ROLLUP))
import Betfair.APING.Types.OrderProjection    (OrderProjection (ALL))
import Betfair.APING.Types.PriceData          (PriceData)
import Betfair.APING.Types.PriceProjection    (PriceProjection (priceData),
                                               defaultPriceProjection)
import Betfair.APING.Types.ResponseMarketBook (Response (result))

data JsonRequest = JsonRequest
  { jsonrpc :: Text
  , method  :: Text
  , params  :: Maybe JsonParameters
  , id      :: Int
  } deriving (Eq, Show)

data JsonParameters = JsonParameters
  { marketIds       :: [Text]
  , priceProjection :: PriceProjection
  , orderProjection :: OrderProjection
  , matchProjection :: MatchProjection
  , currencyCode    :: Text
  , locale          :: Maybe Text
  } deriving (Eq, Show)

defaultJsonParameters :: JsonParameters
defaultJsonParameters =
  JsonParameters [] defaultPriceProjection ALL NO_ROLLUP "GBP" Nothing

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = JsonRequest "2.0" "SportsAPING/v1.0/listMarketBook" (Just jp) 1

listMarketBook :: Context -> JsonParameters -> IO [MarketBook]
listMarketBook c jp =
  groomedLog c =<<
  fmap result . getDecodedResponse c =<<
  (\r -> groomedLog c (jsonRequest jp) >> return r) =<<
  apiRequest c (A.encode $ jsonRequest jp)

type MarketId = Text

marketBook :: Context -> MarketId -> [PriceData] -> IO [MarketBook]
marketBook c mktid pd =
  listMarketBook
    c
    (defaultJsonParameters
     { marketIds = [mktid]
     , priceProjection = defaultPriceProjection {priceData = pd}
     })

marketBooks :: Context -> [MarketId] -> [PriceData] -> IO [MarketBook]
marketBooks c mktids pd =
  listMarketBook
    c
    (defaultJsonParameters
     { marketIds = mktids
     , priceProjection = defaultPriceProjection {priceData = pd}
     })
