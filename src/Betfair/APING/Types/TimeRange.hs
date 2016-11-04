{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.TimeRange
  (TimeRange(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

type DateString = Text

data TimeRange =
  TimeRange {from :: Maybe DateString
            ,to   :: Maybe DateString}
  deriving (Eq,Show)

-- instance Default TimeRange where def = TimeRange "" ""

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''TimeRange)
