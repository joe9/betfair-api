{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseMarketBook
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                    (Options (omitNothingFields),
                                         defaultOptions, deriveJSON)
import Betfair.APING.Types.MarketBook (MarketBook)

data Response =
  Response {jsonrpc :: Text
           ,result  :: [MarketBook]
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
