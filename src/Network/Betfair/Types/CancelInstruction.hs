{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.CancelInstruction
  (CancelInstruction(..))
  where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data CancelInstruction =
  CancelInstruction {betId         :: String
                    ,sizeReduction :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''CancelInstruction

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''CancelInstruction)
