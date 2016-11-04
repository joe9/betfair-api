{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Event
  ( Event(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Protolude

type DateString = Text

data Event = Event
  { id          :: Text
  , name        :: Maybe Text
  , countryCode :: Maybe Text
  , timezone    :: Maybe Text
  , venue       :: Maybe Text
  , openDate    :: Maybe DateString
  } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Event)
