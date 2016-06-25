{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.ErrorData
   ( ErrorData
   ) where

import Data.Aeson.TH   (Options (fieldLabelModifier, omitNothingFields),
                        defaultOptions, deriveJSON)
import Data.Default.TH (deriveDefault)

import Network.Betfair.Types.APINGException (APINGException)
import Network.Betfair.Types.MarketStatus   (MarketStatus)
import Network.Betfair.Types.Runner         (Runner)

type DateString = String

data ErrorData = ErrorData
   { exceptionname  :: String
   , aPINGException :: APINGException
   } deriving (Eq, Show)

deriveDefault ''ErrorData
-- from http://stackoverflow.com/questions/30696089/how-to-handle-capital-case-in-json
$(deriveJSON defaultOptions
              { omitNothingFields = True
              , fieldLabelModifier = let f "aPINGException" = "APINGException"
                                         f other = other
                                     in f
              } ''ErrorData)
