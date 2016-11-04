{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.StartingPrices
  (StartingPrices(..))
  where

import Protolude
import Betfair.APING.Types.PriceSize (PriceSize)
import Data.Aeson.TH                 (Options (omitNothingFields),
                                      defaultOptions, deriveJSON)

data StartingPrices =
  StartingPrices {nearPrice         :: Maybe Double
                 ,farPrice          :: Maybe Double
                 ,backStakeTaken    :: Maybe [PriceSize]
                 ,layLiabilityTaken :: Maybe [PriceSize]
                 ,actualSP          :: Maybe Double}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''StartingPrices)
