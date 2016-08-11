{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.BettingException
  (BettingException(..))
  where

import BasicPrelude
import Betfair.APING.Types.Error (Error)
import Data.Aeson.TH             (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import Data.Default.TH           (deriveDefault)

data BettingException =
  BettingException {jsonrpc :: Text
                   ,error   :: Error
                   ,id      :: Int}
  deriving (Eq,Show)

deriveDefault ''BettingException

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''BettingException)
