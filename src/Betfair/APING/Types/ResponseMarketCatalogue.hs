{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
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
import Text.PrettyPrint.GenericPretty

data Response = Response
  { jsonrpc :: Text
  , result  :: [MarketCatalogue]
  , id      :: Int
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
