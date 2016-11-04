{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceSize
  ( PriceSize(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data PriceSize = PriceSize
  { price :: Double
  , size  :: Double
  } deriving (Eq, Show, Read, Ord)

$(deriveJSON defaultOptions {omitNothingFields = True} ''PriceSize)
