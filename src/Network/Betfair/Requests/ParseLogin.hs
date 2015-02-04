{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Network.Betfair.Requests.ParseLogin
   ( getToken
   , Login(..)
   ) where

import           Safe                        (readNote)
import           Text.JSON.Generic           (Data, Typeable,
                                              decodeJSON)

import           Network.Betfair.Types.Token (Token)

data JsonLogin = JsonLogin
   { token   :: String
   , product :: String
   , status  :: String
   , error   :: String
   } deriving (Eq, Show, Data, Typeable)

data Status = SUCCESS
            | LIMITED_ACCESS
            | LOGIN_RESTRICTED
            | FAIL
   deriving (Eq, Show, Enum, Bounded, Read, Data, Typeable)

data Login = Login
   { lToken            :: Token
   , lProduct          :: String
   , lStatus           :: Status
   , lError            :: String
   , lErrorDescription :: Maybe String
   } deriving (Eq, Show, Data, Typeable)

-- use below in ghci to see how the string is encoded in JSON
-- encodeJSON $ RunnerPrices [RunnerPrice [] [] 1 2]
-- got this idea of reading json data directly to haskell
-- structures from the comments at
-- http://www.amateurtopologist.com/blog/2010/11/05/
--    a-haskell-newbies-guide-to-text-json/
getJsonLogin :: String -> JsonLogin
getJsonLogin = decodeJSON

getLogin :: String -> Login
getLogin = jsonLoginToLogin . getJsonLogin

getToken :: String -> Token
getToken = lToken . getLogin

jsonLoginToLogin :: JsonLogin -> Login
jsonLoginToLogin j =
  Login (token j)
        (Network.Betfair.Requests.ParseLogin.product j)
        (readNote "ParseLogin: cannot read status"
            . status $ j)
        (Network.Betfair.Requests.ParseLogin.error j)
        (lookup (Network.Betfair.Requests.ParseLogin.error j)
                loginExceptionCodes)

type LoginExceptionCodes = [(String,String)]

loginExceptionCodes :: LoginExceptionCodes
loginExceptionCodes =
    [ ("TRADING_MASTER_SUSPENDED","Suspended Trading Master Account")
    , ("TRADING_MASTER","Trading Master Account")
    , ("TELBET_TERMS_CONDITIONS_NA","Telbet terms and conditions rejected")
    , ("SUSPENDED","the account is suspended")
    , ("SPANISH_TERMS_ACCEPTANCE_REQUIRED","The latest spanish terms and conditions version must be accepted")
    , ("SPAIN_MIGRATION_REQUIRED","Spain migration required")
    , ("SELF_EXCLUDED","the account has been self excluded")
    , ("SECURITY_RESTRICTED_LOCATION","the account is restricted due to security concerns")
    , ("SECURITY_QUESTION_WRONG_3X","the user has entered wrong the security question 3 times")
    , ("PERSONAL_MESSAGE_REQUIRED","personal message required for the user")
    , ("PENDING_AUTH","pending authentication")
    , ("NOT_AUTHORIZED_BY_REGULATOR_IT","the user identified by the given credentials is not authorized in the IT's jurisdictions due to the regulators' policies. Ex: the user for which this session should be created is not allowed to act(play, (bet) in the IT's jurisdiction.")
    , ("NOT_AUTHORIZED_BY_REGULATOR_DK","the user identified by the given credentials is not authorized in the DK's jurisdictions due to the regulators' policies. Ex: the user for which this session should be created is not allowed to act(play, (bet) in the DK's jurisdiction.")
    , ("KYC_SUSPEND","KYC suspended")
    , ("ITALIAN_CONTRACT_ACCEPTANCE_REQUIRED","The latest Italian contract version must be accepted")
    , ("INVALID_USERNAME_OR_PASSWORD","the username or password are invalid")
    , ("INVALID_CONNECTIVITY_TO_REGULATOR_IT","the IT regulator cannot be accessed due to some internal problems in the system behind or in at regulator; timeout cases included.")
    , ("INVALID_CONNECTIVITY_TO_REGULATOR_DK","the DK regulator cannot be accessed due to some internal problems in the system behind or in at regulator; timeout cases included.")
    , ("DUPLICATE_CARDS","duplicate cards")
    , ("DENMARK_MIGRATION_REQUIRED","Denmark migration required")
    , ("DANISH_AUTHORIZATION_REQUIRED","Danish authorization required")
    , ("CLOSED ","the account is closed")
    , ("CHANGE_PASSWORD_REQUIRED","change password required")
    , ("CERT_AUTH_REQUIRED","Certificate required or certificate present but could not authenticate with it")
    , ("BETTING_RESTRICTED_LOCATION","the account is accessed from a location where betting is restricted")
    , ("AGENT_CLIENT_MASTER_SUSPENDED","Suspended Agent Client Master")
    , ("AGENT_CLIENT_MASTER","Agent Client Master")
    , ("ACCOUNT_NOW_LOCKED","the account was just locked")
    , ("ACCOUNT_ALREADY_LOCKED","the account is already locked")
    ]

