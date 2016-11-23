{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.Log
  ( Log
  , toLog
  , tracePPLog
  , traceLog
  , stdOutAndLog
  ) where

import Protolude

import Text.PrettyPrint.GenericPretty

import Betfair.APING.API.Context

type Log = Text

-- data Json a = Json {json :: a} deriving (Generic, ToJSON)
toLog :: Context -> Text -> IO ()
toLog = cLogger

ppText
  :: Pretty a
  => a -> Text
ppText = displayPretty

tracePPLog
  :: Pretty a
  => Context -> a -> IO a
tracePPLog c t = (toLog c . ppText) t >> return t

traceLog
  :: Show a
  => Context -> a -> IO a
traceLog c t = (toLog c . Protolude.show) t >> return t

stdOutAndLog :: Context -> Text -> IO ()
stdOutAndLog c s = toLog c s >> putText s
