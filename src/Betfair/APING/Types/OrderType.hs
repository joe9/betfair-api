{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderType
  (OrderType(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data OrderType
  = LIMIT
  | LIMIT_ON_CLOSE
  | MARKET_ON_CLOSE
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''OrderType)
