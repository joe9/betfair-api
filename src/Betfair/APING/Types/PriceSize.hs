{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceSize
  (PriceSize(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data PriceSize =
  PriceSize {price :: Double
            ,size  :: Double}
  deriving (Eq,Show,Read,Ord)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PriceSize)
