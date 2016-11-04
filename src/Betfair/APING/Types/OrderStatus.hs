{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderStatus
  (OrderStatus(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data OrderStatus
  = EXECUTION_COMPLETE
  | EXECUTABLE
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''OrderStatus)
