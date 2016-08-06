{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Requests.CancelOrders
  (cancelOrder
  ,cancelOrderWithParams
  ,JsonParameters(..)
  ,JsonRequest(..))
  where

import           BasicPrelude
import qualified Data.Aeson    as A (encode)
import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)
import           Data.Default  (Default (..))

import Network.Betfair.Requests.APIRequest         (apiRequest)
import Network.Betfair.Requests.Context
import Network.Betfair.Requests.GetResponse        (getDecodedResponse)
import Network.Betfair.Requests.WriterLog          (groomedLog)
import Network.Betfair.Types.BettingException
import Network.Betfair.Types.CancelExecutionReport (CancelExecutionReport)
import Network.Betfair.Types.CancelInstruction     (CancelInstruction)
import Network.Betfair.Types.ResponseCancelOrders  (Response (result))

data JsonRequest =
  JsonRequest {jsonrpc :: Text
              ,method  :: Text
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
  JsonParameters {marketId     :: Text
                 ,instructions :: [CancelInstruction]
                 ,customerRef  :: Text}
  deriving (Eq,Show)

-- deriveDefault ''JsonParameters
instance Default JsonParameters where
  def = JsonParameters "" [] ""

-- instance Default JsonParameters where
--  def = JsonParameters def def def
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonParameters)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

jsonRequest :: JsonParameters -> JsonRequest
jsonRequest jp = def {params = Just jp}

cancelOrderWithParams
  :: Context
  -> JsonParameters
  -> IO (Either (Either Text BettingException) CancelExecutionReport)
cancelOrderWithParams c jp =
  groomedLog c =<<
  fmap (either Left (Right . result)) . getDecodedResponse c =<<
  apiRequest c
             (A.encode $ jsonRequest jp)

type CustomerRef = Text

type MarketId = Text

cancelOrder
  :: Context
  -> MarketId
  -> CancelInstruction
  -> CustomerRef
  -> IO (Either (Either Text BettingException) CancelExecutionReport)
cancelOrder c mktid pin cref =
  groomedLog
    c
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  cancelOrderWithParams c
