{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.Context
  (Context(..)
  ,defaultContext)
  where

import BasicPrelude
import Network.Betfair.Types.AppKey (AppKey)
import Network.Betfair.Types.Token  (Token)
import Network.HTTP.Conduit

data Context =
  Context {cAppKey  :: AppKey
          ,cManager :: Manager
          ,cToken   :: Token
          ,cLogger  :: Text -> IO ()}

defaultContext
  :: Manager -> Maybe (Text -> IO ()) -> Context
defaultContext mgr Nothing =
  Context {cAppKey = ""
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = print}
defaultContext mgr (Just f) =
  Context {cAppKey = ""
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = f}
