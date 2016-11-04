{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExchangePrices
  (ExchangePrices(..))
  where

import Protolude
import Betfair.APING.Types.PriceSize (PriceSize)
import Data.Aeson.TH                 (Options (omitNothingFields),
                                      defaultOptions, deriveJSON)

data ExchangePrices =
  ExchangePrices {availableToBack :: Maybe [PriceSize]
                 ,availableToLay  :: Maybe [PriceSize]
                 ,tradedVolume    :: Maybe [PriceSize]}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExchangePrices)
