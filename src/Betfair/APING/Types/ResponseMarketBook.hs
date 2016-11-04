{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseMarketBook
  (Response(..))
  where

import Protolude
import Betfair.APING.Types.MarketBook (MarketBook)
import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)

data Response =
  Response {jsonrpc :: Text
           ,result  :: [MarketBook]
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
