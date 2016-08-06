{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.ExchangePrices
  (ExchangePrices(..))
  where

import Data.Aeson.TH                   (Options (omitNothingFields),
                                        defaultOptions, deriveJSON)
import Data.Default.TH                 (deriveDefault)
import Network.Betfair.Types.PriceSize (PriceSize)

data ExchangePrices =
  ExchangePrices {availableToBack :: Maybe [PriceSize]
                 ,availableToLay  :: Maybe [PriceSize]
                 ,tradedVolume    :: Maybe [PriceSize]}
  deriving (Eq,Show)

deriveDefault ''ExchangePrices

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExchangePrices)
