{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Competition
  (Competition(..))
  where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data Competition =
  Competition {id   :: String
              ,name :: String}
  deriving (Eq,Show)

deriveDefault ''Competition

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Competition)
