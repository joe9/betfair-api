{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.ListMarketCatalogue
   ( listMarketCatalogue
   , listMarketCatalogueResponseBody
   , listMarketCatalogueResponseBodyString
   , marketCatalogue
   , jsonRequest
   , JsonRequest(..)
   , JsonParameters(..)
   ) where

import           Control.Monad.RWS                             (Monad ((>>), return),
                                                                RWST,
                                                                (=<<))
import qualified Data.Aeson                                    as A (decode, encode)
import           Data.Aeson.TH                                 (Options (omitNothingFields), defaultOptions, deriveJSON)
import qualified Data.ByteString.Lazy                          as L (ByteString)
import           Data.Default                                  (Default (..))
import           Network.HTTP.Conduit                          (Manager)
import           Prelude                                       (Bool (True),
                                                                Eq,
                                                                IO,
                                                                Int, Maybe (Just),
                                                                Show, String,
                                                                ($),
                                                                (.))
import           Safe                                          (fromJustNote)

import           Network.Betfair.Requests.APIRequest           (apiRequest)
import           Network.Betfair.Requests.GetResponse          (getResponseBody, getResponseBodyString)
import           Network.Betfair.Requests.WriterLog            (Log, groomedLog)
import           Network.Betfair.Types.AppKey                  (AppKey)
import           Network.Betfair.Types.MarketCatalogue         (MarketCatalogue)
import           Network.Betfair.Types.MarketFilter            (MarketFilter (marketIds))
import           Network.Betfair.Types.MarketProjection        (MarketProjection)
import           Network.Betfair.Types.MarketSort              (MarketSort)
import           Network.Betfair.Types.ResponseMarketCatalogue (Response (result))
import           Network.Betfair.Types.Token                   (Token)

data JsonRequest = JsonRequest
   { jsonrpc :: String
   , method  :: String
   , params  :: Maybe JsonParameters
   , id      :: Int
   } deriving (Eq, Show)

instance Default JsonRequest where
 def = JsonRequest
          "2.0"
          "SportsAPING/v1.0/listMarketCatalogue"
          (Just def) -- Nothing -- (Just footballOver15MarketCatalogue)
          1

data JsonParameters = JsonParameters
   { filter           :: MarketFilter
   , marketProjection :: Maybe [MarketProjection]
   , sort             :: MarketSort
   , maxResults       :: Int
   , locale           :: Maybe String
   } deriving (Eq, Show)

-- deriveDefault ''JsonParameters
instance Default JsonParameters where
 -- TODO change this back to 1000 after testing
 -- def = JsonParameters def def def 1000 def
 def = JsonParameters def def def 1000 def

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)
$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

-- listMarketCatalogueJsonRequest :: L.ByteString
-- listMarketCatalogueJsonRequest = A.encode (def :: JsonRequest)

-- listMarketCatalogueRequest :: Network.Betfair.Types.Token -> IO Request
-- listMarketCatalogueRequest = apiRequest listMarketCatalogueJsonRequest

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}
-- jsonRequest jp = def {params = Nothing }

type MarketId = String
marketIdJsonRequest :: MarketId -> JsonParameters
marketIdJsonRequest mktid =
   def {filter = def{marketIds = Just[mktid]}}

marketCatalogue :: MarketId -> RWST (AppKey,Token) Log Manager IO [MarketCatalogue]
marketCatalogue mktid = listMarketCatalogue (marketIdJsonRequest mktid)

listMarketCatalogue :: JsonParameters
                    -> RWST (AppKey,Token) Log Manager IO [MarketCatalogue]
listMarketCatalogue jp =
  return . result
               . fromJustNote "listMarketCatalogue: no result"
  =<< groomedLog
  =<< (\b -> return (A.decode b :: Maybe Response))
  =<< getResponseBody
  =<< (\r -> groomedLog (jsonRequest jp) >> return r)
  =<< apiRequest (A.encode $ jsonRequest jp)

listMarketCatalogueResponseBodyString :: JsonParameters
                                      -> RWST (AppKey,Token) Log Manager IO String
listMarketCatalogueResponseBodyString jp =
  getResponseBodyString
  =<< apiRequest (A.encode $ jsonRequest jp)

listMarketCatalogueResponseBody :: JsonParameters
                                -> RWST (AppKey,Token) Log Manager IO L.ByteString
listMarketCatalogueResponseBody jp =
  getResponseBody
  =<< apiRequest (A.encode $ jsonRequest jp)
