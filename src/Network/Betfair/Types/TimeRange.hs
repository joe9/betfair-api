{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.TimeRange
   ( TimeRange(..)
   ) where

import           Data.Aeson.TH   (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import           Data.Default.TH (deriveDefault)

type DateString = String

data TimeRange = TimeRange
   { from :: DateString
   , to   :: DateString
   } deriving (Eq, Show)

-- instance Default TimeRange where def = TimeRange "" ""

deriveDefault ''TimeRange
$(deriveJSON defaultOptions {omitNothingFields = True} ''TimeRange)
