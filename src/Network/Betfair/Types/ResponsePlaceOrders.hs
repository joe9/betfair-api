{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell #-}

module Network.Betfair.Types.ResponsePlaceOrders
   ( Response(..)
   ) where

import           Data.Aeson.TH                              (Options (omitNothingFields), defaultOptions, deriveJSON)

import           Network.Betfair.Types.PlaceExecutionReport (PlaceExecutionReport)

data Response = Response
   { jsonrpc :: String
   , result  :: PlaceExecutionReport
   , id      :: Int
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
