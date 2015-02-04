{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Config
    ( Config(..)
    )
where

import           Prelude (String)

data Config = Config { username      :: String
                     , password      :: String
                     , appKey        :: String
                     , delayedAppKey :: String
                     }

defaultConfig :: Config
defaultConfig = Config "" "" "" ""

-- delayedAppKey :: String
-- delayedAppKey = ""
