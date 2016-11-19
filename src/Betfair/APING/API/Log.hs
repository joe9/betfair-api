{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.Log
  ( Log
  , toLog
  , tracePPLog
  , traceLog
  , stdOutAndLog
  ) where

import           Data.Aeson
import           Data.Aeson.Encode.Pretty
import           Data.String.Conversions
import qualified Data.Text                as T
import           Data.Text.Lazy.Builder
import           Protolude

import Betfair.APING.API.Context

type Log = Text

toLog :: Context -> Text -> IO ()
toLog = cLogger

ppText :: ToJSON a => a -> Text
ppText = toStrict . toLazyText . encodePrettyToTextBuilder

tracePPLog
  :: ToJSON a
  => Context -> a -> IO a
tracePPLog c t = (toLog c . ppText) t >> return t

traceLog
  :: Show a
  => Context -> a -> IO a
traceLog c t = (toLog c . Protolude.show) t >> return t

stdOutAndLog :: Context -> Text -> IO ()
stdOutAndLog c s = toLog c s >> putText s
