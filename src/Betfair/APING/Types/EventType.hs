{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.EventType
  (EventType(..))
  where

import Protolude
import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)

data EventType =
  EventType {id   :: Text
            ,name :: Maybe Text}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''EventType)
