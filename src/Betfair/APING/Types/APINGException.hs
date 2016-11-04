{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Betfair.APING.Types.APINGException
  ( APINGException(..)
  ) where

import Data.Aeson.TH (Options (omitNothingFields), defaultOptions,
                      deriveJSON)
import Data.List
import GHC.Show
import Protolude

data APINGException = APINGException
  { errorDetails :: Text
  , errorCode    :: Text
  , requestUUID  :: Text
  } deriving (Eq, Read)

$(deriveJSON defaultOptions {omitNothingFields = True} ''APINGException)

instance Show APINGException where
  show = toS . showAPINGException

showAPINGException :: APINGException -> Text
showAPINGException a =
  "APINGException: { errorDetails :" <> errorDetails a <> ", errorCode: " <>
  errorCode a <>
  ", errorCodeDescription: " <>
  Protolude.show (lookup (errorCode a) aPINGExceptionCodes) <>
  ", requestUUID: " <>
  requestUUID a <>
  "}"

aPINGExceptionCodes :: [(Text, Text)]
aPINGExceptionCodes =
  [ ( "TOO_MUCH_DATA"
    , "The operation requested too much data, exceeding the Market Data Request Limits.")
  , ( "INVALID_INPUT_DATA"
    , "The data input is invalid. A specific description is returned via errorDetails as shown below.")
  , ( "INVALID_SESSION_INFORMATION"
    , "The session token hasn't been provided, is invalid or has expired.")
  , ( "NO_APP_KEY"
    , "An application key header ('X-Application') has not been provided in the request")
  , ( "NO_SESSION"
    , "A session token header ('X-Authentication') has not been provided in the request")
  , ( "UNEXPECTED_ERROR"
    , "An unexpected internal error occurred that prevented successful request processing.")
  , ( "INVALID_APP_KEY"
    , "The application key passed is invalid or is not present")
  , ( "TOO_MANY_REQUESTS"
    , "There are too many pending requests e.g. a listMarketBook with Order/Match projections is limited to 3 concurrent requests. The error also applies to listCurrentOrders, listMarketProfitAndLoss and listClearedOrders if you have 3 or more requests currently in execution")
  , ( "SERVICE_BUSY"
    , "The service is currently too busy to service this request.")
  , ( "TIMEOUT_ERROR"
    , "The Internal call to downstream service timed out. Please note: If a TIMEOUT_ERROR error occurs on a placeOrders/replaceOrders request, you should check listCurrentOrders to verify the status of your bets before placing further orders. Please allow up to 2 minutes for timed out order to appear.")
  , ( "REQUEST_SIZE_EXCEEDS_LIMIT"
    , "The request exceeds the request size limit. Requests are limited to a total of 250 betId’s/marketId’s (or a combination of both).")
  , ( "ACCESS_DENIED"
    , "The calling client is not permitted to perform the specific action e.g. the using a Delayed App Key when placing bets or attempting to place a bet from a restricted jurisdiction.")
  ]
