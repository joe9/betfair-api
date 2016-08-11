{-# OPTIONS_GHC -Wall #-}

module Log
   ( toLog
   , groomToLog
   , groomLn
   ) where

import Data.Time     (FormatTime, formatTime, getZonedTime)
import System.Locale (defaultTimeLocale)
import Text.Groom    (groom)

toLog :: String -> IO ()
toLog s = filename >>= (\f -> appendFile f (s ++ "\n"))

groomToLog :: Show a => a -> IO ()
groomToLog = toLog . groom

groomLn :: Show a => a -> IO ()
groomLn = putStrLn . groom

filename :: IO String
filename = do
    z <- getZonedTime
    return $ "/home/j/dev/betfair/log/" ++ dateString z ++ "-betfair.log"

dateString :: (FormatTime a) => a -> String
dateString = formatTime defaultTimeLocale "%Y%m%d"

-- filename :: IO String
-- filename = do
--     ct <- getCurrentTime
--     zt <- getZonedTime
--     return $ "log/" ++ dateTimeString ct ++ "-" ++ dateTimeString zt ++ "-betfair.log"

-- dateTimeString :: (FormatTime a) => a -> String
-- dateTimeString = formatTime defaultTimeLocale "%Y%m%d%H%M%S%Z"
