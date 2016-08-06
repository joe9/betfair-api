{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.WriterLog
  (Log
  ,log
  ,groomedLog
  ,stdOutAndLog)
  where

import Control.Monad.RWS (Monad (return, (>>)), MonadTrans (lift),
                          MonadWriter (tell), RWST)
import Prelude           (IO, Show, String, putStrLn, ($), (++), (.))
import Text.Groom        (groom)

type Log = String

log :: String -> IO ()
log = tell . (++ "\n")

groomedLog :: Show a
           => a -> IO a
groomedLog s = (log . groom $ s) >> return s

stdOutAndLog :: String -> IO ()
stdOutAndLog s = log s >> (lift $ putStrLn s)
