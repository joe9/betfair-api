{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Types.ResponseCancelOrders
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                               (Options (omitNothingFields),
                                                    defaultOptions,
                                                    deriveJSON)
import Network.Betfair.Types.CancelExecutionReport (CancelExecutionReport)

data Response =
  Response {jsonrpc :: Text
           ,result  :: CancelExecutionReport
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
