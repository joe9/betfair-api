{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponsePlaceOrders
  ( Response(..)
  ) where

import Betfair.APING.Types.PlaceExecutionReport (PlaceExecutionReport)
import Data.Aeson.TH                            (Options (omitNothingFields),
                                                 defaultOptions,
                                                 deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data Response = Response
  { jsonrpc :: Text
  , result  :: PlaceExecutionReport
  , id      :: Int
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
