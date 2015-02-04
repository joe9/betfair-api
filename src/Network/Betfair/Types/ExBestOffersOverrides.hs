{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.ExBestOffersOverrides
   ( ExBestOffersOverrides(..)
   ) where

import           Data.Aeson.TH                     (Options (omitNothingFields),
                                                    defaultOptions,
                                                    deriveJSON)
import           Data.Default.TH                   (deriveDefault)

import           Network.Betfair.Types.RollupModel (RollupModel)

data ExBestOffersOverrides = ExBestOffersOverrides
   { bestPricesDepth          :: Maybe Int
   , rollupModel              :: RollupModel
   , rollupLimit              :: Maybe Int
   , rollupLiabilityThreshold :: Maybe Double
   , rollupLiabilityFactor    :: Maybe Int
   } deriving (Eq, Show)

deriveDefault ''ExBestOffersOverrides
$(deriveJSON defaultOptions {omitNothingFields = True} ''ExBestOffersOverrides)
