{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.ResponseMarketCatalogue
  ( Response(..)
  ) where

import Betfair.APING.Types.MarketCatalogue (MarketCatalogue)
import Data.Aeson.TH                       (Options (omitNothingFields),
                                            defaultOptions,
                                            deriveJSON)
import Protolude

data Response = Response
  { jsonrpc :: Text
  , result  :: [MarketCatalogue]
  , id      :: Int
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
