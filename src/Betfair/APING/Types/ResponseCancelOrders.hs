{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Betfair.APING.Types.ResponseCancelOrders
  ( Response(..)
  ) where

import Betfair.APING.Types.CancelExecutionReport (CancelExecutionReport)
import Data.Aeson.TH                             (Options (omitNothingFields),
                                                  defaultOptions,
                                                  deriveJSON)
import Protolude
import Text.PrettyPrint.GenericPretty

data Response = Response
  { jsonrpc :: Text
  , result  :: CancelExecutionReport
  , id      :: Int
  } deriving (Eq, Show, Generic, Pretty)

$(deriveJSON defaultOptions {omitNothingFields = True} ''Response)
