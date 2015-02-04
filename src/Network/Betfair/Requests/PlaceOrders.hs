{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.PlaceOrders
   ( placeOrder
   , placeOrderWithParams
   , placeOrdersResponseBodyString
   , JsonParameters(..)
   , JsonRequest(..)
   ) where

import           Control.Monad.RWS                          (RWST)
import qualified Data.Aeson                                 as A (decode, encode)
import           Data.Aeson.TH                              (Options (omitNothingFields), defaultOptions, deriveJSON)
import           Data.Default                               (Default (..))
import           Data.Default.TH                            (deriveDefault)
import           Network.HTTP.Conduit                       (Manager)
import           Safe                                       (fromJustNote)

import           Network.Betfair.Requests.APIRequest        (apiRequest)
import           Network.Betfair.Requests.GetResponse       (getResponseBody, getResponseBodyString)
import           Network.Betfair.Requests.WriterLog         (Log, groomedLog)
import           Network.Betfair.Types.AppKey               (AppKey)
import           Network.Betfair.Types.PlaceExecutionReport (PlaceExecutionReport)
import           Network.Betfair.Types.PlaceInstruction     (PlaceInstruction)
import           Network.Betfair.Types.ResponsePlaceOrders  (Response (result))
import           Network.Betfair.Types.Token                (Token)

data JsonRequest = JsonRequest
   { jsonrpc :: String
   , method  :: String
   , params  :: Maybe JsonParameters
   , id      :: Int
   } deriving (Eq, Show)

instance Default JsonRequest where
 def = JsonRequest
          "2.0"
          "SportsAPING/v1.0/placeOrders"
          (Just def) -- Nothing -- (Just footballOver15MarketCatalogue)
          1

data JsonParameters = JsonParameters
   { marketId     :: String
   , instructions :: [PlaceInstruction]
   , customerRef  :: String
   } deriving (Eq, Show)

deriveDefault ''JsonParameters
-- instance Default JsonParameters where
--  def = JsonParameters def def def

$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonParameters)
$(deriveJSON defaultOptions {omitNothingFields = True} ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

placeOrderWithParams :: JsonParameters
                     -> RWST (AppKey,Token) Log Manager IO PlaceExecutionReport
placeOrderWithParams jp =
 apiRequest (A.encode $ jsonRequest jp)
    >>= getResponseBody
--     >>= (\rb ->  (putStrLn . groom . LUTF8.toString $ rb) >> return rb)
    >>= (\b -> return (A.decode b :: Maybe Response))
    >>= groomedLog
    >>= return . result . fromJustNote "placeOrderWithParams: no result"

--                   >> return . ResponsePlaceOrders.result
-- --                   return . ResponsePlaceOrders.result
--                          . fromJustNote "placeOrderWithParams: no result"
--                          . A.decode
--                          $ rb)

type CustomerRef = String
type MarketId = String
placeOrder :: MarketId -> PlaceInstruction -> CustomerRef
           -> RWST (AppKey,Token) Log Manager IO PlaceExecutionReport
placeOrder mktid pin cref =
 groomedLog (JsonParameters mktid [pin] cref)
  >>= placeOrderWithParams
--   >>= (\per -> (putStrLn $ groom per) >> return per)
-- below lines for debugging
-- placeOrder mktid pin cref _ =
--  (putStrLn $ groom (JsonParameters mktid [pin] cref))
--           >> return def

placeOrdersResponseBodyString ::
   MarketId -> PlaceInstruction -> CustomerRef
   -> RWST (AppKey,Token) Log Manager IO String
placeOrdersResponseBodyString mktid pin cref =
 apiRequest (A.encode . jr $ JsonParameters mktid [pin] (take 32 cref))
    >>= getResponseBodyString
 where jr = jsonRequest
