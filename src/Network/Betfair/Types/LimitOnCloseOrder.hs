{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.LimitOnCloseOrder
  (LimitOnCloseOrder(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data LimitOnCloseOrder =
  LimitOnCloseOrder {liability :: Double
                    ,price     :: Double}
  deriving (Eq,Show)

deriveDefault ''LimitOnCloseOrder

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''LimitOnCloseOrder)
