{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall      #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.StartingPrices
  (StartingPrices(..))
  where

import BasicPrelude
import Betfair.APING.Types.PriceSize (PriceSize)
import Data.Aeson.TH                 (Options (omitNothingFields),
                                      defaultOptions, deriveJSON)
import Data.Default.TH               (deriveDefault)

data StartingPrices =
  StartingPrices {nearPrice         :: Maybe Double
                 ,farPrice          :: Maybe Double
                 ,backStakeTaken    :: Maybe [PriceSize]
                 ,layLiabilityTaken :: Maybe [PriceSize]
                 ,actualSP          :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''StartingPrices

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''StartingPrices)
