{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import BasicPrelude hiding (bracket, error, filter, finally)
-- import           Control.Concurrent.Async
import Control.Exception.Safe
import Data.Default           (Default (def))
import Network.HTTP.Client    (managerSetProxy, noProxy)
import Network.HTTP.Conduit
--
import Betfair.APING
import Betfair.APING.Requests.ListMarketCatalogue (JsonParameters (filter, marketProjection),
                                                   listMarketCatalogue)
import Betfair.APING.Types.MarketFilter
import Betfair.APING.Types.MarketProjection       (MarketProjection (COMPETITION, EVENT, EVENT_TYPE, MARKET_START_TIME, RUNNER_DESCRIPTION))

type MarketId = Text

type UserName = Text

type Password = Text

-- app key from betfair subscription
main :: IO ()
main =
  void (getMarketCatalogue (undefined :: AppKey)
                           (undefined :: UserName)
                           (undefined :: Password))

getMarketCatalogue
  :: AppKey -> UserName -> Password -> IO ()
getMarketCatalogue appKey username password =
  do manager <- newManager (managerSetProxy noProxy tlsManagerSettings)
     let context =
           initializeContext manager
                             appKey
                             (Just putStr)
     bracket (fmap (\token -> context {cToken = token})
                   (sessionToken context username password))
             (\updatedContext ->
                putStrLn "Logging out" >> logout updatedContext)
             (\updatedContext ->
                do print (cToken updatedContext)
                   _ <-
                     (tennisAndCricketMarketCatalogues updatedContext >>= print)
                   --                    (_,_) <-
                   --                      concurrently
                   --                        (tennisAndCricketMarketCatalogues updatedContext >>=
                   --                         print)
                   --                        (keepAliveOnceEvery10Minutes updatedContext)
                   return ())
     return ()

-- event types
-- 1 Soccer 13904
-- 2 Tennis 3615
-- 3 Golf 89
-- 4 Cricket 170
-- 5 Rugby Union 10
marketCatalogueParams :: JsonParameters
marketCatalogueParams =
  def {filter =
         def {eventTypeIds = (Just . fmap show) ([2 :: Integer,4])
             ,marketTypeCodes = Just ["MATCH_ODDS"]}
      ,
         -- The weight of all the below are 0.
         --   Hence, I should get the maximum of 1000 markets
         marketProjection =
         Just [EVENT
              ,EVENT_TYPE -- already know this
              ,COMPETITION
              ,MARKET_START_TIME
              ,RUNNER_DESCRIPTION]}

tennisAndCricketMarketCatalogues
  :: Context -> IO [MarketCatalogue]
tennisAndCricketMarketCatalogues context =
  listMarketCatalogue context marketCatalogueParams
