{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall        #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseCancelOrders
  (Response(..))
  where

import BasicPrelude
import Betfair.APING.Types.CancelExecutionReport (CancelExecutionReport)
import Data.Aeson.TH                             (Options (omitNothingFields),
                                                  defaultOptions,
                                                  deriveJSON)

data Response =
  Response {jsonrpc :: Text
           ,result  :: CancelExecutionReport
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
