{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.ErrorData
  (ErrorData(..))
  where

import Protolude
import Betfair.APING.Types.APINGException (APINGException)
import Data.Aeson.TH                      (Options (fieldLabelModifier, omitNothingFields),
                                           defaultOptions, deriveJSON)

data ErrorData =
  ErrorData {exceptionname  :: Text
            ,aPINGException :: APINGException}
  deriving (Eq,Read,Show)


-- from http://stackoverflow.com/questions/30696089/how-to-handle-capital-case-in-json
$(deriveJSON
    defaultOptions {omitNothingFields = True
                   ,fieldLabelModifier =
                      let f "aPINGException" = "APINGException"
                          f other            = other
                      in f}
    ''ErrorData)
