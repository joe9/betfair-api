{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.Order
  (Order(..))
  where

import Data.Aeson.TH                         (Options (omitNothingFields),
                                              defaultOptions,
                                              deriveJSON)
import Data.Default.TH                       (deriveDefault)
import Network.Betfair.Types.OrderStatus     (OrderStatus)
import Network.Betfair.Types.OrderType       (OrderType)
import Network.Betfair.Types.PersistenceType (PersistenceType)
import Network.Betfair.Types.Side            (Side)

type DateString = String

data Order =
  Order {betId           :: String
        ,orderType       :: OrderType
        ,status          :: OrderStatus
        ,persistenceType :: PersistenceType
        ,side            :: Side
        ,price           :: Maybe Double
        ,size            :: Maybe Double
        ,bspLiability    :: Maybe Double
        ,placedDate      :: Maybe DateString
        ,avgPriceMatched :: Maybe Double
        ,sizeMatched     :: Maybe Double
        ,sizeRemaining   :: Maybe Double
        ,sizeLapsed      :: Maybe Double
        ,sizeCancelled   :: Maybe Double
        ,sizeVoided      :: Maybe Double}
  deriving (Eq,Show)

deriveDefault ''Order

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Order)
