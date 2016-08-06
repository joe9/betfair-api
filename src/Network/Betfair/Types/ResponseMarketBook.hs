{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Types.ResponseMarketBook
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                    (Options (omitNothingFields),
                                         defaultOptions, deriveJSON)
import Network.Betfair.Types.MarketBook (MarketBook)

data Response =
  Response {jsonrpc :: Text
           ,result  :: [MarketBook]
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
