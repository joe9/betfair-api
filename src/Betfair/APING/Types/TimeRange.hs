{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall      #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.TimeRange
  (TimeRange(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

type DateString = Text

data TimeRange =
  TimeRange {from :: DateString
            ,to   :: DateString}
  deriving (Eq,Show)

-- instance Default TimeRange where def = TimeRange "" ""
deriveDefault ''TimeRange

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''TimeRange)
