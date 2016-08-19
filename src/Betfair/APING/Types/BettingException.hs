{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.BettingException
  (BettingException(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)
--
import Betfair.APING.Types.Error (Error)

data BettingException =
  BettingException {jsonrpc :: Text
                   ,error   :: Error
                   ,id      :: Int}
  deriving (Eq,Read,Show,Typeable)

deriveDefault ''BettingException

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''BettingException)

instance Exception BettingException
