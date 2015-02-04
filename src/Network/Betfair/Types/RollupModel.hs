{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable   #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.RollupModel
   ( RollupModel(..)
   ) where

import           Data.Aeson.TH   (Options (omitNothingFields),
                                  defaultOptions, deriveJSON)
import           Data.Default.TH (deriveDefault)

data RollupModel = NONE
                     | STAKE
                     | PAYOUT
                     | MANAGED_LIABILITY
   deriving (Eq, Show)

deriveDefault ''RollupModel
$(deriveJSON defaultOptions {omitNothingFields = True} ''RollupModel)
