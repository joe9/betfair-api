{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.LimitOrder
  (LimitOrder(..))
  where

import BasicPrelude
import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Data.Default.TH                       (deriveDefault)
import Betfair.APING.Types.PersistenceType (PersistenceType)

data LimitOrder =
  LimitOrder {size            :: Double
             ,price           :: Double
             ,persistenceType :: PersistenceType}
  deriving (Eq,Show)

deriveDefault ''LimitOrder

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''LimitOrder)
