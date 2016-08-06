{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.MarketDescription
  (MarketDescription(..))
  where

import BasicPrelude
import Data.Aeson.TH                           (Options (omitNothingFields),
                                                defaultOptions,
                                                deriveJSON)
import Network.Betfair.Types.MarketBettingType (MarketBettingType)

type DateString = Text

data MarketDescription =
  MarketDescription {persistenceEnabled :: Bool
                    ,bspMarket          :: Bool
                    ,marketTime         :: DateString
                    ,suspendTime        :: DateString
                    ,settleTime         :: Maybe DateString
                    ,bettingType        :: MarketBettingType
                    ,turnInPlayEnabled  :: Bool
                    ,marketType         :: Text
                    ,regulator          :: Text
                    ,marketBaseRate     :: Double
                    ,discountAllowed    :: Bool
                    ,wallet             :: Maybe Text
                    ,rules              :: Maybe Text
                    ,rulesHasDate       :: Maybe Bool
                    ,eachWayDivisor     :: Maybe Double
                    ,clarifications     :: Maybe Text}
  deriving (Eq,Show)

-- deriveDefault ''MarketDescription
$(deriveJSON defaultOptions {omitNothingFields = True}
             ''MarketDescription)
