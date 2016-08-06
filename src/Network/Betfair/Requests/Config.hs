{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Config
  (Config(..)
  ,defaultConfig)
  where

import Network.Betfair.Types.AppKey (AppKey)
import Prelude                      (String)

data Config =
  Config {username      :: String
         ,password      :: String
         ,appKey        :: AppKey
         ,delayedAppKey :: AppKey}

defaultConfig :: Config
defaultConfig = Config "" "" "" ""
