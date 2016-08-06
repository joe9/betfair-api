{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Types.ResponsePlaceOrders
  (Response(..))
  where

import BasicPrelude
import Data.Aeson.TH                              (Options (omitNothingFields),
                                                   defaultOptions,
                                                   deriveJSON)
import Network.Betfair.Types.PlaceExecutionReport (PlaceExecutionReport)

data Response =
  Response {jsonrpc :: Text
           ,result  :: PlaceExecutionReport
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
