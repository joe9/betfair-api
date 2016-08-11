{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE NoImplicitPrelude #-}

module ManagerSettings ( managerSettings ) where

import Data.Default         (Default (def))
import Network.Connection   (ProxySettings (SockSettingsSimple))
import Network.HTTP.Conduit (ManagerSettings, mkManagerSettings)

import Masked.Prelude

managerSettings :: ManagerSettings
managerSettings = settings useProxy

settings :: UseProxy -> ManagerSettings
settings True  = mkManagerSettings
                     def
                     (Just $ SockSettingsSimple "127.0.0.1" 8080)
settings False = mkManagerSettings def Nothing

type UseProxy = Bool
useProxy :: UseProxy
useProxy = False
