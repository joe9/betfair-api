{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall      #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.MarketStatus
  (MarketStatus(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data MarketStatus
  = INACTIVE
  | OPEN
  | SUSPENDED
  | CLOSED
  deriving (Eq,Show,Read,Enum)

deriveDefault ''MarketStatus

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketStatus)
