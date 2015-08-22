{-# OPTIONS_GHC -Wall #-}

module Over15LaysMarketCatalogue
   ( dailyOver15LaysMarketCatalogue
   , hourlyOver15LaysMarketCatalogue
   , periodOver15LaysMarketCatalogue
   ) where

import           Prelude                                      hiding (filter)

import           Control.Monad.RWS                            (RWST)
import           Data.Default                                 (Default (def))
import           Data.Time.Clock                              (NominalDiffTime, UTCTime, addUTCTime)
import           Data.Time.ISO8601                            (formatISO8601Millis)
import           Network.HTTP.Conduit                         (Manager)

import           Network.Betfair.Types.AppKey                 (AppKey)
import           Network.Betfair.Types.Competition            (Competition)
import qualified Network.Betfair.Types.Competition            as Competition (id)
import           Network.Betfair.Types.MarketBettingType      (MarketBettingType)
import           Network.Betfair.Types.MarketCatalogue        (MarketCatalogue)
import           Network.Betfair.Types.MarketFilter           (MarketFilter (competitionIds, eventTypeIds, marketBettingTypes, marketTypeCodes, marketStartTime))
import           Network.Betfair.Types.MarketProjection       (MarketProjection (COMPETITION, EVENT, EVENT_TYPE, MARKET_START_TIME, RUNNER_DESCRIPTION))
import           Network.Betfair.Types.TimeRange              (TimeRange (TimeRange))
import           Network.Betfair.Types.Token                  (Token)

import           Network.Betfair.Requests.ListMarketCatalogue (JsonParameters (marketProjection, filter), listMarketCatalogue)
import           Network.Betfair.Requests.WriterLog           (Log)


type MarketTypeCode = String
marketCatalogueParams ::
 [Competition] -> MarketTypeCode -> TimeRange -> JsonParameters
marketCatalogueParams competitions mktTypeCode tmeRange =
 def { filter =
          def { eventTypeIds = Just ["1"] -- from listEventTypes
              , marketBettingTypes = [def :: MarketBettingType]
              , marketTypeCodes = Just [mktTypeCode]
              , marketStartTime = Just tmeRange
              , competitionIds = toCompetitionIdsFilter competitions
              -- , turnInPlayEnabled = Just True
              }
-- The weight of all the below are 0.
--   Hence, I should get the maximum of 1000 markets
     , marketProjection = Just  [ EVENT
                                , EVENT_TYPE -- already know this
                                , COMPETITION
                                , MARKET_START_TIME
                                , RUNNER_DESCRIPTION
                                ]
     }

toCompetitionIdsFilter :: [Competition] -> Maybe [String]
toCompetitionIdsFilter [] = Nothing
toCompetitionIdsFilter xs = Just $ map Competition.id xs

timeRange :: NominalDiffTime -> UTCTime -> TimeRange
timeRange interval time = TimeRange start end
  where end   = formatISO8601Millis $ addUTCTime interval time
        start = formatISO8601Millis time

hourlyTimeRange :: UTCTime -> TimeRange
hourlyTimeRange = timeRange 3600

dailyTimeRange :: UTCTime -> TimeRange
dailyTimeRange = timeRange 86400

dailyOver15LaysMarketCatalogue :: UTCTime
                               -> RWST (AppKey,Token) Log Manager IO [MarketCatalogue]
dailyOver15LaysMarketCatalogue time =
 listMarketCatalogue $
    marketCatalogueParams [] "OVER_UNDER_15" (dailyTimeRange time)

hourlyOver15LaysMarketCatalogue :: UTCTime
                                -> RWST (AppKey,Token) Log Manager IO [MarketCatalogue]
hourlyOver15LaysMarketCatalogue time =
 listMarketCatalogue $
    marketCatalogueParams [] "OVER_UNDER_15" (hourlyTimeRange time)

periodOver15LaysMarketCatalogue ::
 [Competition] -> NominalDiffTime -> UTCTime
 -> RWST (AppKey, Token) Log Manager IO [MarketCatalogue]
periodOver15LaysMarketCatalogue competitions period time =
 listMarketCatalogue $
    marketCatalogueParams
       competitions "OVER_UNDER_15" (timeRange period time)
