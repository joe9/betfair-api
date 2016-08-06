{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Error
  (Error)
  where

import Data.Aeson.TH                   (Options (fieldLabelModifier, omitNothingFields),
                                        defaultOptions, deriveJSON)
import Data.Default.TH                 (deriveDefault)
import Network.Betfair.Types.ErrorData (ErrorData)

data Error =
  Error {code      :: Integer
        ,message   :: String
        ,errorData :: Maybe ErrorData}
  deriving ((Eq))

deriveDefault ''Error

-- from http://stackoverflow.com/questions/30696089/how-to-handle-capital-case-in-json
$(deriveJSON
    defaultOptions {omitNothingFields = True
                   ,fieldLabelModifier =
                      let f "errorData" = "data"
                          f other       = other
                      in f}
    ''Error)

instance Show Error where
  show = showError

showError :: Error -> String
showError a =
  "Error: { code :" ++
  show (code a) ++
  ", description: " ++
  show (lookup (code a) errorCodes) ++
  ", message: " ++ message a ++ ", data: " ++ show (errorData a) ++ "}"

errorCodes :: [(Integer,String)]
errorCodes =
  [(-32099,"APING Exception.")
  ,(-32700
   ,"Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.")
  ,(-32601,"Method not found")
  ,(-32602
   ,"Problem parsing the parameters, or a mandatory parameter was not found")
  ,(-32603,"Internal JSON-RPC error")]
