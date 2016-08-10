{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.OrderStatus
  (OrderStatus(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data OrderStatus
  = EXECUTION_COMPLETE
  | EXECUTABLE
  deriving (Eq,Show)

deriveDefault ''OrderStatus

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''OrderStatus)
