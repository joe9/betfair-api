{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.PriceLadderDescription
  ( PriceLadderDescription(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

import Text.PrettyPrint.GenericPretty

import Betfair.APING.Types.PriceLadderType (PriceLadderType)

data PriceLadderDescription = PriceLadderDescription
  { ptype :: PriceLadderType
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON
    defaultOptions {omitNothingFields = True, fieldLabelModifier = drop 1}
    ''PriceLadderDescription)
