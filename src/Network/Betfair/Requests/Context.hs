{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.Requests.Context
  (Context(..)
  ,initializeContext)
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

initializeContext
  :: Manager -> Maybe (Text -> IO ()) -> Context
initializeContext mgr Nothing =
  Context {cAppKey = ""
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = print}
initializeContext mgr (Just f) =
  Context {cAppKey = ""
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = f}
