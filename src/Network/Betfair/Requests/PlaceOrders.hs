{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.PlaceOrders
  (placeOrder
  ,placeOrderWithParams
  ,placeOrdersResponseBodyString
  ,JsonParameters(..)
  ,JsonRequest(..))
  where

import           Control.Monad.RWS
import qualified Data.Aeson                                 as A (encode)
import           Data.Aeson.TH                              (Options (omitNothingFields),
                                                             defaultOptions,
                                                             deriveJSON)
import           Data.Default                               (Default (..))
import           Data.Default.TH                            (deriveDefault)
import           Network.Betfair.Requests.APIRequest        (apiRequest)
import           Network.Betfair.Requests.GetResponse       (getResponseBody,
                                                             getResponseBodyString)
import           Network.Betfair.Requests.WriterLog         (Log, groomedLog)
import           Network.Betfair.Types.AppKey               (AppKey)
import           Network.Betfair.Types.BettingException
import           Network.Betfair.Types.PlaceExecutionReport (PlaceExecutionReport)
import           Network.Betfair.Types.PlaceInstruction     (PlaceInstruction)
import           Network.Betfair.Types.ResponsePlaceOrders  (Response (result))
import           Network.Betfair.Types.Token                (Token)
import           Network.HTTP.Conduit                       (Manager)

data JsonRequest =
  JsonRequest {jsonrpc :: String
              ,method  :: String
              ,params  :: Maybe JsonParameters
              ,id      :: Int}
  deriving (Eq,Show)

instance Default JsonRequest where
  def =
    JsonRequest "2.0"
                "SportsAPING/v1.0/placeOrders"
                (Just def)
                1

data JsonParameters =
  JsonParameters {marketId     :: String
                 ,instructions :: [PlaceInstruction]
                 ,customerRef  :: String}
  deriving (Eq,Show)

deriveDefault ''JsonParameters

-- instance Default JsonParameters where
--  def = JsonParameters def def def
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

placeOrderWithParams
  :: JsonParameters
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) PlaceExecutionReport)
placeOrderWithParams jp =
  groomedLog =<<
  fmap (either Left (Right . result)) . getResponseBody =<<
  apiRequest (A.encode $ jsonRequest jp)

type CustomerRef = String

type MarketId = String

placeOrder
  :: MarketId
  -> PlaceInstruction
  -> CustomerRef
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) PlaceExecutionReport)
placeOrder mktid pin cref =
  groomedLog
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  placeOrderWithParams

--   >>= (\per -> (putStrLn $ groom per) >> return per)
-- below lines for debugging
-- placeOrder mktid pin cref _ =
--  (putStrLn $ groom (JsonParameters mktid [pin] cref))
--           >> return def
placeOrdersResponseBodyString
  :: MarketId
  -> PlaceInstruction
  -> CustomerRef
  -> RWST (AppKey,Token) Log Manager IO String
placeOrdersResponseBodyString mktid pin cref =
  apiRequest
    (A.encode . jr $
     JsonParameters mktid
                    [pin]
                    (take 32 cref)) >>=
  getResponseBodyString
  where jr = jsonRequest
