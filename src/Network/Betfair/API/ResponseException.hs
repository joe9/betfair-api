{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.API.ResponseException
  (ResponseException(..))
  where

import BasicPrelude

import Network.Betfair.Types.BettingException
import Network.Betfair.Types.Login

data ResponseException
  = BettingException BettingException
  | ParserError Text
  | LoginError Login
  deriving (Eq,Show)
