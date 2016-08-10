{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall  #-}

module Network.Betfair.API.WriterLog
  (Log
  ,toLog
  ,groomedLog
  ,stdOutAndLog)
  where

import BasicPrelude
import Data.String.Conversions
-- import Data.Text
import Text.Groom (groom)
--
import Network.Betfair.API.Context

type Log = Text

toLog :: Context -> Text -> IO ()
toLog c = cLogger c

groomedLog :: Show a
           => Context -> a -> IO a
groomedLog c s = (toLog c . cs . groom) s >> return s

stdOutAndLog :: Context -> Text -> IO ()
stdOutAndLog c s = toLog c s >> putStrLn s
