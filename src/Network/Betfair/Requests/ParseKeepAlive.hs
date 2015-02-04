{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Network.Betfair.Requests.ParseKeepAlive
   ( KeepAlive(..)
   , getKeepAlive
   ) where

import           Safe
import           Text.JSON.Generic

import           Network.Betfair.Types.Token (Token)

data JsonKeepAlive = JsonKeepAlive
   { token   :: String
   , product :: String
   , status  :: String
   , error   :: String
   } deriving (Eq, Show, Data, Typeable)

data Status = SUCCESS
            | FAIL
   deriving (Eq, Show, Enum, Bounded, Read, Data, Typeable)

data Error = INPUT_VALIDATION_ERROR
            | INTERNAL_ERROR
            | NO_SESSION
   deriving (Eq, Show, Enum, Bounded, Read, Data, Typeable)

data KeepAlive = KeepAlive
   { lToken   :: Token
   , lProduct :: String
   , lStatus  :: Status
   , lError   :: Error
   } deriving (Eq, Show, Data, Typeable)

-- use below in ghci to see how the string is encoded in JSON
-- encodeJSON $ RunnerPrices [RunnerPrice [] [] 1 2]
-- got this idea of reading json data directly to haskell
-- structures from the comments at
-- http://www.amateurtopologist.com/blog/2010/11/05/
--    a-haskell-newbies-guide-to-text-json/
getJsonKeepAlive :: String -> JsonKeepAlive
getJsonKeepAlive = decodeJSON

getKeepAlive :: String -> KeepAlive
getKeepAlive = jsonKeepAliveToKeepAlive . getJsonKeepAlive

jsonKeepAliveToKeepAlive :: JsonKeepAlive -> KeepAlive
jsonKeepAliveToKeepAlive j =
   KeepAlive (token j)
            (Network.Betfair.Requests.ParseKeepAlive.product j)
            (readNote "ParseKeepAlive: cannot read status"
                . status $ j)
            (readNote "ParseKeepAlive: cannot read error"
                . Network.Betfair.Requests.ParseKeepAlive.error $ j)

