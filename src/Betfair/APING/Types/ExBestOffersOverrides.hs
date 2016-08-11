{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExBestOffersOverrides
  (ExBestOffersOverrides(..))
  where

import BasicPrelude
import Betfair.APING.Types.RollupModel (RollupModel)
import Data.Aeson.TH                   (Options (omitNothingFields),
                                        defaultOptions, deriveJSON)
import Data.Default.TH                 (deriveDefault)

data ExBestOffersOverrides =
  ExBestOffersOverrides {bestPricesDepth          :: Maybe Int
                        ,rollupModel              :: RollupModel
                        ,rollupLimit              :: Maybe Int
                        ,rollupLiabilityThreshold :: Maybe Double
                        ,rollupLiabilityFactor    :: Maybe Int}
  deriving (Eq,Show)

deriveDefault ''ExBestOffersOverrides

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExBestOffersOverrides)
