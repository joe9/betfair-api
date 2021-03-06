{-# LANGUAGE DeriveAnyClass       #-}
{-# LANGUAGE DeriveGeneric        #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.BettingException
  ( BettingException(..)
  ) where

import Data.Aeson.TH                  (Options (omitNothingFields),
                                       defaultOptions, deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

--
import Betfair.APING.Types.Error (Error)

data BettingException = BettingException
  { jsonrpc :: Text
  , error   :: Error
  , id      :: Int
  } deriving (Eq, Read, Show, Generic, Pretty, Typeable)

$(deriveJSON defaultOptions {omitNothingFields = True} ''BettingException)

instance Exception BettingException
