{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Event
  (Event(..))
  where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)

type DateString = String

data Event =
  Event {id          :: String
        ,name        :: Maybe String
        ,countryCode :: Maybe String
        ,timezone    :: Maybe String
        ,venue       :: Maybe String
        ,openDate    :: Maybe DateString}
  deriving (Eq,Show)

-- deriveDefault ''Event
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Event)
