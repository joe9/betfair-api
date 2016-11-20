{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.TimeRange
  ( TimeRange(..)
  ) where

import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

type DateString = Text

data TimeRange = TimeRange
  { from :: Maybe DateString
  , to   :: Maybe DateString
  } deriving (Eq, Show, Generic, Pretty)

-- instance Default TimeRange where def = TimeRange "" ""
$(deriveJSON defaultOptions {omitNothingFields = True} ''TimeRange)
