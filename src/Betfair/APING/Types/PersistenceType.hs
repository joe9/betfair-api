{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.PersistenceType
  ( PersistenceType(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data PersistenceType
  = LAPSE
  | PERSIST
  | MARKET_ON_CLOSE
  deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''PersistenceType)
