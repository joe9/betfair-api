{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MatchProjection
  ( MatchProjection(..)
  ) where

import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data MatchProjection
  = NO_ROLLUP
  | ROLLED_UP_BY_PRICE
  | ROLLED_UP_BY_AVG_PRICE
  deriving (Eq, Show, Generic, Pretty)

-- $(deriveJSON id ''Record)
$(deriveJSON defaultOptions {omitNothingFields = True} ''MatchProjection)
