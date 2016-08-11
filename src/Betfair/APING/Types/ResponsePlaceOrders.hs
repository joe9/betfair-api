{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall     #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponsePlaceOrders
  (Response(..))
  where

import BasicPrelude
import Betfair.APING.Types.PlaceExecutionReport (PlaceExecutionReport)
import Data.Aeson.TH                            (Options (omitNothingFields),
                                                 defaultOptions,
                                                 deriveJSON)

data Response =
  Response {jsonrpc :: Text
           ,result  :: PlaceExecutionReport
           ,id      :: Int}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Response)
