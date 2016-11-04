{-# LANGUAGE NoImplicitPrelude  #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Betfair.APING.Types.PersistenceType
  (PersistenceType(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data PersistenceType
  = LAPSE
  | PERSIST
  | MARKET_ON_CLOSE
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''PersistenceType)
