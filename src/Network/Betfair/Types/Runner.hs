{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Runner
  (Runner(..))
  where

import Data.Aeson.TH                        (Options (omitNothingFields),
                                             defaultOptions,
                                             deriveJSON)
import Data.Default.TH                      (deriveDefault)
import Network.Betfair.Types.ExchangePrices (ExchangePrices)
import Network.Betfair.Types.Match          (Match)
import Network.Betfair.Types.Order          (Order)
import Network.Betfair.Types.RunnerStatus   (RunnerStatus)
import Network.Betfair.Types.StartingPrices (StartingPrices)

type DateString = String

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

deriveDefault ''Runner

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Runner)
