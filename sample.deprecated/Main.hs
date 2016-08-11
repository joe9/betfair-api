{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE NoImplicitPrelude #-}

import Control.Monad.RWS    (RWST (runRWST))
import Network.HTTP.Conduit (closeManager, newManager)
import Text.Groom           (groom)

import Masked.Prelude

import Network.Betfair.Requests.Config (Config (appKey))
import Network.Betfair.Requests.Login  (sessionToken)
import Network.Betfair.Requests.Logout (logout)

import Config          (config)
import Log             (toLog)
import ManagerSettings (managerSettings)
import Over15Lays      (over15Lays)

main :: IO ()
main = do
  manager <- newManager managerSettings
  (token,_,loggedOutput) <- runRWST (sessionToken config) undefined manager

  toLog loggedOutput
  toLog $ "Token received: " ++ groom token
  toLog "Running Over15Lays strategy on Over/Under 1.5 Goals:"

  putStrLn $ "Token received: " ++ groom token
  putStrLn "Running Over15Lays strategy on Over/Under 1.5 Goals:"

  (_,_,loggedOutput1) <- runRWST over15Lays (appKey config,token) manager
  toLog loggedOutput1

  (logoutStatus,_,loggedOutput2) <- runRWST logout
                                (appKey config,token)
                                manager
  toLog loggedOutput2
  toLog $ "Logout Status: " ++ groom logoutStatus

  putStrLn $ "logged out: " ++ groom logoutStatus

  closeManager manager
  return ()
