{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Requests.CancelOrders
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
--
import Betfair.APING.API.APIRequest              (apiRequest)
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse             (getDecodedResponse)
import Betfair.APING.API.Log                     (groomedLog)
import Betfair.APING.Types.CancelExecutionReport (CancelExecutionReport)
import Betfair.APING.Types.CancelInstruction     (CancelInstruction)
import Betfair.APING.Types.ResponseCancelOrders  (Response (result))

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
  :: Context -> JsonParameters -> IO CancelExecutionReport
cancelOrderWithParams c jp =
  groomedLog c =<<
  fmap result . getDecodedResponse c =<<
  apiRequest c
             (A.encode $ jsonRequest jp)

type CustomerRef = Text

type MarketId = Text

cancelOrder :: Context
            -> MarketId
            -> CancelInstruction
            -> CustomerRef
            -> IO CancelExecutionReport
cancelOrder c mktid pin cref =
  groomedLog
    c
    (JsonParameters mktid
                    [pin]
                    cref) >>=
  cancelOrderWithParams c
