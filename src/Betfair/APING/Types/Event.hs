{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Event
  (Event(..))
  where

import BasicPrelude
import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)

type DateString = Text

data Event =
  Event {id          :: Text
        ,name        :: Maybe Text
        ,countryCode :: Maybe Text
        ,timezone    :: Maybe Text
        ,venue       :: Maybe Text
        ,openDate    :: Maybe DateString}
  deriving (Eq,Show)

-- deriveDefault ''Event
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Event)
