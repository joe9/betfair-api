{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseMarketBook
  ( Response(..)
  ) where

import Betfair.APING.Types.MarketBook (MarketBook)
import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude

data Response = Response
  { jsonrpc :: Text
  , result  :: [MarketBook]
  , id      :: Int
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
