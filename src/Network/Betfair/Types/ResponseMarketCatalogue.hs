{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Network.Betfair.Types.ResponseMarketCatalogue
   ( Response(..)
   ) where

import           Data.Aeson.TH                         (Options (omitNothingFields), defaultOptions,
                                                        deriveJSON)

import           Network.Betfair.Types.MarketCatalogue (MarketCatalogue)

data Response = Response
   { jsonrpc :: String
   , result  :: [MarketCatalogue]
   , id      :: Int
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
