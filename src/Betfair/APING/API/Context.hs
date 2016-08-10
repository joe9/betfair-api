{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.Context
  (Context(..)
  ,initializeContext)
  where

import BasicPrelude
import Betfair.APING.Types.AppKey (AppKey)
import Betfair.APING.Types.Token  (Token)
import Network.HTTP.Conduit

data Context =
  Context {cAppKey :: AppKey
          ,cManager :: Manager
          ,cToken :: Token
          ,cLogger :: Text -> IO ()}

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
