{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.Order
  (Order(..))
  where

import Protolude
import Betfair.APING.Types.OrderStatus     (OrderStatus)
import Betfair.APING.Types.OrderType       (OrderType)
import Betfair.APING.Types.PersistenceType (PersistenceType)
import Betfair.APING.Types.Side            (Side)
import Data.Aeson.TH                       (Options (omitNothingFields),
                                            defaultOptions,
                                            deriveJSON)

type DateString = Text

data Order =
  Order {betId           :: Text
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


$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Order)
