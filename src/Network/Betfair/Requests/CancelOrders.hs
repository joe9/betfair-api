{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.CancelOrders
  (cancelOrder
  ,cancelOrderWithParams
  ,cancelOrdersResponseBodyString
  ,JsonParameters(..)
  ,JsonRequest(..))
  where

import           Control.Monad.RWS                           (RWST)
import qualified Data.Aeson                                  as A (encode)
import           Data.Aeson.TH                               (Options (omitNothingFields),
                                                              defaultOptions,
                                                              deriveJSON)
import           Data.Default                                (Default (..))
import           Data.Default.TH                             (deriveDefault)
import           Network.Betfair.Requests.APIRequest         (apiRequest)
import           Network.Betfair.Requests.GetResponse        (getResponseBody,
                                                              getResponseBodyString)
import           Network.Betfair.Requests.WriterLog          (Log, groomedLog)
import           Network.Betfair.Types.AppKey                (AppKey)
import           Network.Betfair.Types.CancelExecutionReport (CancelExecutionReport)
import           Network.Betfair.Types.CancelInstruction     (CancelInstruction)
import           Network.Betfair.Types.ResponseCancelOrders  (Response (result))
import           Network.Betfair.Types.Token                 (Token)
import Network.Betfair.Types.BettingException
import           Network.HTTP.Conduit                        (Manager)

data JsonRequest =
  JsonRequest {jsonrpc :: String
              ,method  :: String
              ,params  :: Maybe JsonParameters
              ,id      :: Int}
  deriving (Eq,Show)

instance Default JsonRequest where
  def =
    JsonRequest "2.0"
                "SportsAPING/v1.0/cancelOrders"
                (Just def)
                1

data JsonParameters =
  JsonParameters {marketId     :: String
                 ,instructions :: [CancelInstruction]
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

cancelOrderWithParams
  :: JsonParameters
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) CancelExecutionReport)
cancelOrderWithParams jp =
  groomedLog =<<
  fmap (either Left (Right . result)) . getResponseBody =<<
  apiRequest (A.encode $ jsonRequest jp)

type CustomerRef = String

type MarketId = String

cancelOrder
  :: MarketId
  -> CancelInstruction
  -> CustomerRef
  -> RWST (AppKey,Token) Log Manager IO (Either (Either String BettingException) CancelExecutionReport)
cancelOrder mktid pin cref =
  groomedLog
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  cancelOrderWithParams

--   >>= (\per -> (putStrLn $ groom per) >> return per)
-- below lines for debugging
-- cancelOrder mktid pin cref _ =
--  (putStrLn $ groom (JsonParameters mktid [pin] cref))
--           >> return def
cancelOrdersResponseBodyString
  :: MarketId
  -> CancelInstruction
  -> CustomerRef
  -> RWST (AppKey,Token) Log Manager IO String
cancelOrdersResponseBodyString mktid pin cref =
  apiRequest
    (A.encode . jr $
     JsonParameters mktid
                    [pin]
                    cref) >>=
  getResponseBodyString
  where jr = jsonRequest
