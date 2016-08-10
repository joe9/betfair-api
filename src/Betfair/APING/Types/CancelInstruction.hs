{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstruction
  (CancelInstruction(..))
  where

import BasicPrelude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data CancelInstruction =
  CancelInstruction {betId :: Text
                    ,sizeReduction :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''CancelInstruction

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstruction)
