{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Context
  (Context(..)
  ,defaultContext)
  where

import Network.Betfair.Types.AppKey (AppKey)
import Prelude                      (String)

data Context =
  Context {username      :: String
         ,password      :: String
         ,appKey        :: AppKey
         ,delayedAppKey :: AppKey}

defaultContext :: Context
defaultContext = Context "" "" "" ""
