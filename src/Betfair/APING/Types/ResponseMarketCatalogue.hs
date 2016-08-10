{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.ResponseMarketCatalogue
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Betfair.APING.Types.MarketCatalogue (MarketCatalogue)

data Response =
  Response {jsonrpc :: Text
           ,result  :: [MarketCatalogue]
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
