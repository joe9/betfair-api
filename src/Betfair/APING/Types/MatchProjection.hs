{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MatchProjection
  ( MatchProjection(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data MatchProjection
  = NO_ROLLUP
  | ROLLED_UP_BY_PRICE
  | ROLLED_UP_BY_AVG_PRICE
  deriving (Eq, Show)

-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True} ''MatchProjection)
