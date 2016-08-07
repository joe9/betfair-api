{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Types.Login
  (Login(..),LoginExceptionCodes, loginExceptionCodes)
  where

import           BasicPrelude         hiding (error)
import           Data.Aeson
import           Data.Aeson.TH

import Network.Betfair.Types.Token            (Token)

data Login =
  Login {token            :: Maybe Token
        ,product          :: Text
        ,status           :: Status
        ,error            :: Text
        ,errorDescription :: Maybe Text}
  deriving (Eq,Show)

data Status
  = SUCCESS
  | LIMITED_ACCESS
  | LOGIN_RESTRICTED
  | FAIL
  deriving (Eq,Show,Read)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Status)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''Login)

type LoginExceptionCodes = [(Text,Text)]

loginExceptionCodes :: LoginExceptionCodes
loginExceptionCodes =
  [("TRADING_MASTER_SUSPENDED","Suspended Trading Master Account")
  ,("TRADING_MASTER","Trading Master Account")
  ,("TELBET_TERMS_CONDITIONS_NA","Telbet terms and conditions rejected")
  ,("SUSPENDED","the account is suspended")
  ,("SPANISH_TERMS_ACCEPTANCE_REQUIRED"
   ,"The latest spanish terms and conditions version must be accepted")
  ,("SPAIN_MIGRATION_REQUIRED","Spain migration required")
  ,("SELF_EXCLUDED","the account has been self excluded")
  ,("SECURITY_RESTRICTED_LOCATION"
   ,"the account is restricted due to security concerns")
  ,("SECURITY_QUESTION_WRONG_3X"
   ,"the user has entered wrong the security question 3 times")
  ,("PERSONAL_MESSAGE_REQUIRED","personal message required for the user")
  ,("PENDING_AUTH","pending authentication")
  ,("NOT_AUTHORIZED_BY_REGULATOR_IT"
   ,"the user identified by the given credentials is not authorized in the IT's jurisdictions due to the regulators' policies. Ex: the user for which this session should be created is not allowed to act(play, (bet) in the IT's jurisdiction.")
  ,("NOT_AUTHORIZED_BY_REGULATOR_DK"
   ,"the user identified by the given credentials is not authorized in the DK's jurisdictions due to the regulators' policies. Ex: the user for which this session should be created is not allowed to act(play, (bet) in the DK's jurisdiction.")
  ,("KYC_SUSPEND","KYC suspended")
  ,("ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED"
   ,"The latest Italian contract version must be accepted")
  ,("INVALID_USERNAME_OR_PASSWORD","the username or password are invalid")
  ,("INVALID_CONNECTIVITY_TO_REGULATOR_IT"
   ,"the IT regulator cannot be accessed due to some internal problems in the system behind or in at regulator; timeout cases included.")
  ,("INVALID_CONNECTIVITY_TO_REGULATOR_DK"
   ,"the DK regulator cannot be accessed due to some internal problems in the system behind or in at regulator; timeout cases included.")
  ,("DUPLICATE_CARDS","duplicate cards")
  ,("DENMARK_MIGRATION_REQUIRED","Denmark migration required")
  ,("DANISH_AUTHORIZATION_REQUIRED","Danish authorization required")
  ,("CLOSED ","the account is closed")
  ,("CHANGE_PASSWORD_REQUIRED","change password required")
  ,("CERT_AUTH_REQUIRED"
   ,"Certificate required or certificate present but could not authenticate with it")
  ,("BETTING_RESTRICTED_LOCATION"
   ,"the account is accessed from a location where betting is restricted")
  ,("AGENT_CLIENT_MASTER_SUSPENDED","Suspended Agent Client Master")
  ,("AGENT_CLIENT_MASTER","Agent Client Master")
  ,("ACCOUNT_NOW_LOCKED","the account was just locked")
  ,("ACCOUNT_ALREADY_LOCKED","the account is already locked")]
