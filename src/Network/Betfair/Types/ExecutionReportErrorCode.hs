{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE UndecidableInstances #-}

module Network.Betfair.Types.ExecutionReportErrorCode
  (ExecutionReportErrorCode(..))
  where

import Data.Aeson.TH   (Options (omitNothingFields), defaultOptions,
                        deriveJSON)
import Data.Default.TH (deriveDefault)

data ExecutionReportErrorCode
  = ERROR_IN_MATCHER
  | PROCESSED_WITH_ERRORS
  | BET_ACTION_ERROR
  | INVALID_ACCOUNT_STATE
  | INVALID_WALLET_STATUS
  | INSUFFICIENT_FUNDS
  | LOSS_LIMIT_EXCEEDED
  | MARKET_SUSPENDED
  | MARKET_NOT_OPEN_FOR_BETTING
  | DUPLICATE_TRANSACTION
  | INVALID_ORDER
  | INVALID_MARKET_ID
  | PERMISSION_DENIED
  | DUPLICATE_BETIDS
  | NO_ACTION_REQUIRED
  | SERVICE_UNAVAILABLE
  | REJECTED_BY_REGULATOR
  deriving (Eq,Show)

deriveDefault ''ExecutionReportErrorCode

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''ExecutionReportErrorCode)
