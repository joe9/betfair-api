{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Error
   ( Error
   ) where

import Data.Aeson.TH   (Options (fieldLabelModifier, omitNothingFields),
                        defaultOptions, deriveJSON)
import Data.Default.TH (deriveDefault)

import Network.Betfair.Types.ErrorData    (ErrorData)
import Network.Betfair.Types.MarketStatus (MarketStatus)
import Network.Betfair.Types.Runner       (Runner)

type DateString = String

data Error = Error
   { code    :: Integer
   , message :: String
   , eData   :: Maybe ErrorData
   } deriving (Eq, Show)

deriveDefault ''Error
-- from http://stackoverflow.com/questions/30696089/how-to-handle-capital-case-in-json
$(deriveJSON defaultOptions
              { omitNothingFields = True
              , fieldLabelModifier = let f "eData" = "Data"
                                         f other = other
                                     in f
              } ''Error)
