{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceProjection
  ( PriceProjection(..)
  , defaultPriceProjection
  ) where

import Betfair.APING.Types.ExBestOffersOverrides (ExBestOffersOverrides(..))
import Betfair.APING.Types.RollupModel (RollupModel(NONE))
import Betfair.APING.Types.PriceData             (PriceData (EX_ALL_OFFERS, EX_TRADED))
import Data.Aeson.TH                             (Options (omitNothingFields),
                                                  defaultOptions,
                                                  deriveJSON)
import Protolude

data PriceProjection = PriceProjection
  { priceData             :: [PriceData]
  , exBestOffersOverrides :: ExBestOffersOverrides
  , virtualise            :: Bool
  , rollOverStakes        :: Bool
  } deriving (Eq, Show)

defaultPriceProjection :: PriceProjection
defaultPriceProjection =
  PriceProjection
    [EX_ALL_OFFERS, EX_TRADED]
    (ExBestOffersOverrides Nothing NONE Nothing Nothing Nothing)
    True
    False

-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True} ''PriceProjection)
