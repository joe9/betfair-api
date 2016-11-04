{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.StartingPrices
  ( StartingPrices(..)
  ) where

import Betfair.APING.Types.PriceSize (PriceSize)
import Data.Aeson.TH                 (Options (omitNothingFields),
                                      defaultOptions, deriveJSON)
import Protolude

data StartingPrices = StartingPrices
  { nearPrice         :: Maybe Double
  , farPrice          :: Maybe Double
  , backStakeTaken    :: Maybe [PriceSize]
  , layLiabilityTaken :: Maybe [PriceSize]
  , actualSP          :: Maybe Double
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''StartingPrices)
