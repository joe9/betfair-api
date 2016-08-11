{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceData
  (PriceData(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data PriceData
  = EX_ALL_OFFERS
  | EX_BEST_OFFERS
  | SP_AVAILABLE
  | SP_TRADED
  | EX_TRADED
  deriving (Eq,Show)

deriveDefault ''PriceData

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PriceData)
