{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall        #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Side
  (Side(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data Side
  = BACK
  | LAY
  deriving (Eq,Show)

deriveDefault ''Side

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Side)
