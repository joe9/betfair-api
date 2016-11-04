{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.CancelInstruction
  (CancelInstruction(..))
  where

import Protolude
import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)

data CancelInstruction =
  CancelInstruction {betId         :: Text
                    ,sizeReduction :: Maybe Double}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstruction)
