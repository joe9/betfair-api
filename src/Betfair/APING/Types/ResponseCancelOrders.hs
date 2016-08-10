{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseCancelOrders
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                               (Options (omitNothingFields),
                                                    defaultOptions,
                                                    deriveJSON)
import Betfair.APING.Types.CancelExecutionReport (CancelExecutionReport)

data Response =
  Response {jsonrpc :: Text
           ,result  :: CancelExecutionReport
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
