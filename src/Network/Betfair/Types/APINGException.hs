{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.APINGException
   ( APINGException(..)
   ) where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data APINGException = APINGException
   { errorDetails :: String
   , errorCode    :: String
   , requestUUID  :: String
   } deriving (Eq, Show)

deriveDefault ''APINGException
$(deriveJSON defaultOptions {omitNothingFields = True} ''APINGException)
