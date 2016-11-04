{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.LimitOrder
  ( LimitOrder(..)
  ) where

import Betfair.APING.Types.PersistenceType (PersistenceType)
import Data.Aeson.TH                       (Options (omitNothingFields),
                                            defaultOptions,
                                            deriveJSON)
import Protolude

data LimitOrder = LimitOrder
  { size            :: Double
  , price           :: Double
  , persistenceType :: PersistenceType
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''LimitOrder)
