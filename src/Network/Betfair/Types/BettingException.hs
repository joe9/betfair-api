{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.BettingException
   ( BettingException(..)
   ) where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

import Network.Betfair.Types.Error (Error)

data BettingException = BettingException
   { jsonrpc :: String
   , error   :: Error
   , id      :: Int
   } deriving (Eq, Show)

deriveDefault ''BettingException
$(deriveJSON defaultOptions {omitNothingFields = True} ''BettingException)
