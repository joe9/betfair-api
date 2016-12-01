{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Common.Types
  ( SelectionId
  , MarketId
  , EventName
  , MarketName
  , RunnerName
  , PointId
  , Token
  , AppKey
  , Price
  , Size
  ) where

import Protolude

import Betfair.APING

type MarketId = Text

type SelectionId = Integer

type EventName = Text

type MarketName = Text

type RunnerName = Text

type PointId = Int

type Price = Double

type Size = Double
