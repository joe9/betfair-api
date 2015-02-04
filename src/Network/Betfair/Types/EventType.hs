{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.EventType
   ( EventType(..)
   ) where

import           Data.Aeson.TH (Options (omitNothingFields),
                                defaultOptions, deriveJSON)

data EventType = EventType
   { id   :: String
   , name :: Maybe String
   } deriving (Eq, Show)

$(deriveJSON defaultOptions {omitNothingFields = True} ''EventType)
