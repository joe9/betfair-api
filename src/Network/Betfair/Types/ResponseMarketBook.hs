{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell #-}

module Network.Betfair.Types.ResponseMarketBook
   ( Response(..)
   ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)

import Network.Betfair.Types.MarketBook (MarketBook)

data Response = Response
   { jsonrpc :: String
   , result  :: [MarketBook]
   , id      :: Int
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
