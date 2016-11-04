{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ExBestOffersOverrides
  ( ExBestOffersOverrides(..)
  ) where

import Betfair.APING.Types.RollupModel (RollupModel)
import Data.Aeson.TH                   (Options (omitNothingFields),
                                        defaultOptions, deriveJSON)
import Protolude

data ExBestOffersOverrides = ExBestOffersOverrides
  { bestPricesDepth          :: Maybe Int
  , rollupModel              :: RollupModel
  , rollupLimit              :: Maybe Int
  , rollupLiabilityThreshold :: Maybe Double
  , rollupLiabilityFactor    :: Maybe Int
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''ExBestOffersOverrides)
