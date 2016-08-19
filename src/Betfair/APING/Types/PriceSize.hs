{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceSize
  (PriceSize(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data PriceSize =
  PriceSize {price :: Double
            ,size  :: Double}
  deriving (Eq,Show,Read,Ord)

deriveDefault ''PriceSize

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PriceSize)
