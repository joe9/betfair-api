{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.EventType
  ( EventType(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

data EventType = EventType
  { id   :: Text
  , name :: Maybe Text
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''EventType)
