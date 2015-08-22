{-# OPTIONS_GHC -Wall #-}

module Config ( config ) where

import           Network.Betfair.Requests.Config (Config (..))

config :: Config
config = Config { username = "username"
                , password = "password"
                , appKey   = "appkey"
                , delayedAppKey = "delayedAppKey"
                }
