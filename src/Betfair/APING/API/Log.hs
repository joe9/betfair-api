{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.Log
  (Log
  ,toLog
  ,groomedLog
  ,stdOutAndLog)
  where

import Protolude
-- import Data.Text
import Text.Groom (groom)
--
import Betfair.APING.API.Context

type Log = Text

toLog :: Context -> Text -> IO ()
toLog = cLogger

groomedLog :: Show a
           => Context -> a -> IO a
groomedLog c s = (toLog c . toS . groom) s >> return s

stdOutAndLog :: Context -> Text -> IO ()
stdOutAndLog c s = toLog c s >> putText s
