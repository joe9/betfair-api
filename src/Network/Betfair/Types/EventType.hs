{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.EventType
  (EventType(..))
  where

import BasicPrelude
import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)

data EventType =
  EventType {id   :: Text
            ,name :: Maybe Text}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''EventType)
