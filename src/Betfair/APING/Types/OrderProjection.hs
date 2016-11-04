{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderProjection
  ( OrderProjection(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data OrderProjection
  = ALL
  | EXECUTABLE
  | EXECUTION_COMPLETE
  deriving (Eq, Show)

-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True} ''OrderProjection)
