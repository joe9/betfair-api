{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Runner
  (Runner(..))
  where

import Protolude
import Betfair.APING.Types.ExchangePrices (ExchangePrices)
import Betfair.APING.Types.Match          (Match)
import Betfair.APING.Types.Order          (Order)
import Betfair.APING.Types.RunnerStatus   (RunnerStatus)
import Betfair.APING.Types.StartingPrices (StartingPrices)
import Data.Aeson.TH                      (Options (omitNothingFields),
                                           defaultOptions, deriveJSON)

type DateString = Text

data Runner =
  Runner {selectionId      :: Integer
         ,handicap         :: Double
         ,status           :: RunnerStatus
         ,adjustmentFactor :: Maybe Double
         ,lastPriceTraded  :: Maybe Double
         ,totalMatched     :: Maybe Double
         ,removalDate      :: Maybe DateString
         ,sp               :: Maybe StartingPrices
         ,ex               :: Maybe ExchangePrices
         ,orders           :: Maybe [Order]
         ,matches          :: Maybe [Match]}
  deriving (Eq,Show)


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Runner)
