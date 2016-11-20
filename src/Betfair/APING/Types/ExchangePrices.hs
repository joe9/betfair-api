{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExchangePrices
  ( ExchangePrices(..)
  ) where

import Betfair.APING.Types.PriceSize  (PriceSize)
import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data ExchangePrices = ExchangePrices
  { availableToBack :: Maybe [PriceSize]
  , availableToLay  :: Maybe [PriceSize]
  , tradedVolume    :: Maybe [PriceSize]
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''ExchangePrices)
