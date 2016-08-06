{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.PriceProjection
  (PriceProjection(..))
  where

import BasicPrelude
import Data.Aeson.TH                               (Options (omitNothingFields),
                                                    defaultOptions,
                                                    deriveJSON)
import Data.Default                                (Default (..))
import Network.Betfair.Types.ExBestOffersOverrides (ExBestOffersOverrides)
import Network.Betfair.Types.PriceData             (PriceData (EX_ALL_OFFERS, EX_TRADED))

data PriceProjection =
  PriceProjection {priceData             :: [PriceData]
                  ,exBestOffersOverrides :: ExBestOffersOverrides
                  ,virtualise            :: Bool
                  ,rollOverStakes        :: Bool}
  deriving (Eq,Show)

instance Default PriceProjection where
  def =
    PriceProjection [EX_ALL_OFFERS,EX_TRADED]
                    def
                    True
                    False

-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PriceProjection)
