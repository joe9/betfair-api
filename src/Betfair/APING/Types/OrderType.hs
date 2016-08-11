{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderType
  (OrderType(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data OrderType
  = LIMIT
  | LIMIT_ON_CLOSE
  | MARKET_ON_CLOSE
  deriving (Eq,Show)

deriveDefault ''OrderType

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''OrderType)
