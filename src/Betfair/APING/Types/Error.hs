{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Error
  ( Error(..)
  ) where

import Data.Aeson.TH           (Options (fieldLabelModifier, omitNothingFields),
                                defaultOptions, deriveJSON)
import Data.List
import Data.String.Conversions (cs)
import GHC.Show
import Protolude

import Betfair.APING.Types.ErrorData (ErrorData)

data Error = Error
  { code      :: Integer
  , message   :: Text
  , errorData :: Maybe ErrorData
  } deriving (Eq, Read)

-- from http://stackoverflow.com/questions/30696089/how-to-handle-capital-case-in-json
$(deriveJSON
    defaultOptions
    { omitNothingFields = True
    , fieldLabelModifier =
        let f "errorData" = "data"
            f other       = other
        in f
    }
    ''Error)

instance Show Error where
  show = cs . showError

showError :: Error -> Text
showError a =
  "Error: { code :" <> Protolude.show (code a) <> ", description: " <>
  Protolude.show (lookup (code a) errorCodes) <>
  ", message: " <>
  message a <>
  ", data: " <>
  Protolude.show (errorData a) <>
  "}"

errorCodes :: [(Integer, Text)]
errorCodes =
  [ (-32099, "APING Exception.")
  , ( -32700
    , "Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.")
  , (-32601, "Method not found")
  , ( -32602
    , "Problem parsing the parameters, or a mandatory parameter was not found")
  , (-32603, "Internal JSON-RPC error")
  ]
