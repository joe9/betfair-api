{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.LimitOnCloseOrder
  ( LimitOnCloseOrder(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data LimitOnCloseOrder = LimitOnCloseOrder
  { liability :: Double
  , price     :: Double
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''LimitOnCloseOrder)
