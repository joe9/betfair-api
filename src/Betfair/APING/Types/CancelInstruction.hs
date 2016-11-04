{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstruction
  ( CancelInstruction(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data CancelInstruction = CancelInstruction
  { betId         :: Text
  , sizeReduction :: Maybe Double
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''CancelInstruction)
