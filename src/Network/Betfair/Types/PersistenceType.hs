{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}

module Network.Betfair.Types.PersistenceType
   ( PersistenceType(..)
   ) where

import           Data.Aeson.TH   (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import           Data.Default.TH (deriveDefault)

data PersistenceType = LAPSE | PERSIST | MARKET_ON_CLOSE
   deriving (Eq, Show)

deriveDefault ''PersistenceType
$(deriveJSON defaultOptions {omitNothingFields = True} ''PersistenceType)
