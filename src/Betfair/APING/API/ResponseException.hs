{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.API.ResponseException
  (ResponseException(..))
  where

import BasicPrelude
--
import Betfair.APING.Types.BettingException
import Betfair.APING.Types.Login

data ResponseException
  = BettingException BettingException
  | ParserError Text
  deriving (Eq,Read,Show,Typeable)

instance Exception ResponseException
