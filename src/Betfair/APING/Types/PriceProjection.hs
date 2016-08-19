{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall        #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceProjection
  (PriceProjection(..))
  where

import BasicPrelude
import Betfair.APING.Types.ExBestOffersOverrides (ExBestOffersOverrides)
import Betfair.APING.Types.PriceData             (PriceData (EX_ALL_OFFERS, EX_TRADED))
import Data.Aeson.TH                             (Options (omitNothingFields),
                                                  defaultOptions,
                                                  deriveJSON)
import Data.Default                              (Default (..))

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
