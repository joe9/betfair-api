{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell #-}

module Network.Betfair.Types.ResponseCancelOrders
   ( Response(..)
   ) where

import           Data.Aeson.TH                               (Options (omitNothingFields), defaultOptions, deriveJSON)

import           Network.Betfair.Types.CancelExecutionReport (CancelExecutionReport)

data Response = Response
   { jsonrpc :: String
   , result  :: CancelExecutionReport
   , id      :: Int
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
