{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExchangePrices
  (ExchangePrices(..))
  where

import BasicPrelude
import Betfair.APING.Types.PriceSize (PriceSize)
import Data.Aeson.TH                 (Options (omitNothingFields),
                                      defaultOptions, deriveJSON)
import Data.Default.TH               (deriveDefault)

data ExchangePrices =
  ExchangePrices {availableToBack :: Maybe [PriceSize]
                 ,availableToLay  :: Maybe [PriceSize]
                 ,tradedVolume    :: Maybe [PriceSize]}
  deriving (Eq,Show)

deriveDefault ''ExchangePrices

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExchangePrices)
