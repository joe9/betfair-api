{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExBestOffersOverrides
  (ExBestOffersOverrides(..))
  where

import Protolude
import Betfair.APING.Types.RollupModel (RollupModel)
import Data.Aeson.TH                   (Options (omitNothingFields),
                                        defaultOptions, deriveJSON)

data ExBestOffersOverrides =
  ExBestOffersOverrides {bestPricesDepth          :: Maybe Int
                        ,rollupModel              :: RollupModel
                        ,rollupLimit              :: Maybe Int
                        ,rollupLiabilityThreshold :: Maybe Double
                        ,rollupLiabilityFactor    :: Maybe Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExBestOffersOverrides)
