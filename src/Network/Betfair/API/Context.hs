{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Network.Betfair.API.Context
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
  :: Manager -> AppKey -> Maybe (Text -> IO ()) -> Context
initializeContext mgr a Nothing =
  Context {cAppKey = a
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = print}
initializeContext mgr a (Just f) =
  Context {cAppKey = a
          ,cToken = ""
          ,cManager = mgr
          ,cLogger = f}
