{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.ListMarketBook
   ( JsonParameters(..)
   , listMarketBook
   , listMarketBookResponseBodyString
   , marketBook
   , marketBooks
   , JsonRequest(..)
   ) where

import           Control.Monad.RWS    (RWST)
import qualified Data.Aeson           as A (decode, encode)
import           Data.Aeson.TH        (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import           Data.Default         (Default (..))
import           Network.HTTP.Conduit (Manager)

import Network.Betfair.Requests.APIRequest      (apiRequest)
import Network.Betfair.Requests.GetResponse     (getResponseBody,
                                                 getResponseBodyString)
import Network.Betfair.Requests.WriterLog       (Log, groomedLog)
import Network.Betfair.Types.AppKey             (AppKey)
import Network.Betfair.Types.MarketBook         (MarketBook)
import Network.Betfair.Types.MatchProjection    (MatchProjection)
import Network.Betfair.Types.OrderProjection    (OrderProjection)
import Network.Betfair.Types.PriceData          (PriceData)
import Network.Betfair.Types.PriceProjection    (PriceProjection (priceData))
import Network.Betfair.Types.ResponseMarketBook (Response (result))
import Network.Betfair.Types.Token              (Token)

data JsonRequest = JsonRequest
   { jsonrpc :: String
   , method  :: String
   , params  :: Maybe JsonParameters
   , id      :: Int
   } deriving (Eq, Show)

instance Default JsonRequest where
 def = JsonRequest
          "2.0"
          "SportsAPING/v1.0/listMarketBook"
          (Just def) -- Nothing -- (Just footballOver15MarketCatalogue)
          1

data JsonParameters = JsonParameters
   { marketIds       :: [String]
   , priceProjection :: PriceProjection
   , orderProjection :: OrderProjection
   , matchProjection :: MatchProjection
   , currencyCode    :: String
   , locale          :: Maybe String
   } deriving (Eq, Show)

-- deriveDefault ''JsonParameters
instance Default JsonParameters where
 def = JsonParameters def def def def "GBP" def

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)
$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

listMarketBook :: JsonParameters
               -> RWST (AppKey,Token) Log Manager IO [MarketBook]
listMarketBook jp = do
  return . concatMap result
  =<< groomedLog
  =<< (\b -> return (A.decode b :: Maybe Response))
  =<< getResponseBody
  =<< apiRequest (A.encode $ jsonRequest jp)

type MarketId = String
marketBook :: MarketId -> [PriceData]
           -> RWST (AppKey,Token) Log Manager IO [MarketBook]
marketBook mktid pd =
    listMarketBook (def { marketIds = [mktid]
                        , priceProjection = def {priceData = pd}
                        })

marketBooks :: [MarketId] -> [PriceData]
           -> RWST (AppKey,Token) Log Manager IO [MarketBook]
marketBooks mktids pd =
    listMarketBook (def { marketIds = mktids
                        , priceProjection = def {priceData = pd}
                        })

listMarketBookResponseBodyString :: String
                               -> RWST (AppKey,Token) Log Manager IO String
listMarketBookResponseBodyString mktid =
  getResponseBodyString
  =<< apiRequest (A.encode . jsonRequest $ def {marketIds = [mktid]})
