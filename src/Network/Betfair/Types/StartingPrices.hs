{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.StartingPrices
   ( StartingPrices(..)
   ) where

import           Data.Aeson.TH                   (Options (omitNothingFields),
                                                  defaultOptions,
                                                  deriveJSON)
import           Data.Default.TH                 (deriveDefault)

import           Network.Betfair.Types.PriceSize (PriceSize)

data StartingPrices = StartingPrices
   { nearPrice         :: Maybe Double
   , farPrice          :: Maybe Double
   , backStakeTaken    :: Maybe [PriceSize]
   , layLiabilityTaken :: Maybe [PriceSize]
   , actualSP          :: Maybe Double
   } deriving (Eq, Show)

deriveDefault ''StartingPrices
$(deriveJSON defaultOptions {omitNothingFields = True} ''StartingPrices)
