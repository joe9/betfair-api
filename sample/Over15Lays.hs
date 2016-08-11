{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE UndecidableInstances #-}

module Over15Lays
   ( over15Lays
   ) where

import Control.Monad.RWS    (Monad ((>>), (>>=), return),
                             MonadTrans (lift), RWST, mapM_)
import Data.Char            (isSpace)
import Data.Maybe           (Maybe (..))
import Data.Time.Clock      (addUTCTime, getCurrentTime)
import Data.Time.ISO8601    (formatISO8601Millis)
import Network.HTTP.Conduit (Manager)
import Safe                 (fromJustNote, headNote)

import Masked.Data.List (filter, intercalate, map, take, unwords,
                         (++))
import Masked.Prelude   (Double, Eq ((/=), (==)), IO, Int, Integer,
                         Num ((*)), Ord ((>)), Show (show), String,
                         fromIntegral, not, otherwise, putStr, ($),
                         (.))

import           Network.Betfair.Requests.CancelOrders       (cancelOrder)
import           Network.Betfair.Requests.PlaceOrders        (placeOrder)
import           Network.Betfair.Requests.Log          (Log, groomedLog, stdOutAndLog)
import           Network.Betfair.Types.AppKey                (AppKey)
import           Network.Betfair.Types.CancelExecutionReport (CancelExecutionReport (CancelExecutionReport))
import qualified Network.Betfair.Types.CancelExecutionReport as CER (CancelExecutionReport (status))
import           Network.Betfair.Types.CancelInstruction     (CancelInstruction (CancelInstruction))
import           Network.Betfair.Types.Competition           (Competition (Competition))
import           Network.Betfair.Types.Event                 (Event (name))
import           Network.Betfair.Types.ExchangePrices        (ExchangePrices (availableToBack))
import qualified Network.Betfair.Types.ExecutionReportStatus as ERS (ExecutionReportStatus (SUCCESS))
import           Network.Betfair.Types.LimitOrder            (LimitOrder (LimitOrder))
import           Network.Betfair.Types.MarketBook            (MarketBook (runners))
import qualified Network.Betfair.Types.MarketBook            as MarketBook (MarketBook (status))
import           Network.Betfair.Types.MarketCatalogue       (MarketCatalogue (event, marketId, marketStartTime))
import qualified Network.Betfair.Types.MarketCatalogue       as MarketCatalogue (runners)
import           Network.Betfair.Types.MarketStatus          (MarketStatus (OPEN))
import           Network.Betfair.Types.Order                 (Order (betId, sizeRemaining))
import qualified Network.Betfair.Types.Order                 as Order (Order (price, status))
import           Network.Betfair.Types.OrderStatus           (OrderStatus (EXECUTABLE))
import           Network.Betfair.Types.OrderType             (OrderType (LIMIT))
import           Network.Betfair.Types.PersistenceType       (PersistenceType (LAPSE))
import           Network.Betfair.Types.PlaceExecutionReport  (PlaceExecutionReport (PlaceExecutionReport))
import qualified Network.Betfair.Types.PlaceExecutionReport  as PER (PlaceExecutionReport (status))
import           Network.Betfair.Types.PlaceInstruction      (PlaceInstruction (PlaceInstruction, handicap, limitOnCloseOrder, limitOrder, marketOnCloseOrder, orderType, side))
import qualified Network.Betfair.Types.PlaceInstruction      as PlaceInstruction (selectionId)
import           Network.Betfair.Types.PriceSize             (PriceSize (price))
import           Network.Betfair.Types.Runner                (Runner (ex, orders, selectionId))
import qualified Network.Betfair.Types.Runner                as Runner (Runner (status))
import           Network.Betfair.Types.RunnerCatalog         (RunnerCatalog (runnerName))
import qualified Network.Betfair.Types.RunnerCatalog         as RunnerCatalog (selectionId)
import           Network.Betfair.Types.RunnerStatus          (RunnerStatus (ACTIVE))
import           Network.Betfair.Types.Side                  (Side (LAY))
import           Network.Betfair.Types.Token                 (Token)

import CompetitionName           (competitionName)
import MarketBook                (getMarketBook, noOrderInMarket,
                                  showMarketBook)
import Over15LaysMarketCatalogue (periodOver15LaysMarketCatalogue)

type MarketId = String

over15Lays :: RWST (AppKey,Token) Log Manager IO ()
over15Lays =
  lift getCurrentTime
--     >>= (return . addUTCTime 3600)
    >>= (return . addUTCTime 1800)
    >>= (\t -> stdOutAndLog ( "Running for "
                            ++ show noOfDays
                            ++ " days from: "
                            ++ formatISO8601Millis t)
                 >> return t)
--     >> return ()
    >>= (periodOver15LaysMarketCatalogue
                 desirableCompetitions
                 (86400 * fromIntegral noOfDays))
--     >>= flip dailyOver15LaysMarketCatalogue token
    -- >>= flip hourlyOver15LaysMarketCatalogue token
--     >>= return . filter isDesirableMarket
--     >>= mapM_ checkAndPlaceOrder
    -- to place orders, uncomment the above line
    --   and comment out the below line
    >>= (\_ -> return ())

noOfDays :: Int
noOfDays = 10

betSize :: Double
betSize = 8

desirableCompetitions :: [Competition]
desirableCompetitions =
   map (\(i,n) -> Competition i n)
        [ -- ("2005", "UEFA Europa League")
          ("31", "Barclays Premier League")
--         , ("33", "The Championship")
        , ("81", "Serie A")
--         , ("55", "Ligue 1 Orange")
--         , ("228", "UEFA Champions League")
--         , ("4655", "Copa Sudamericana")
--         , ("133", "Swiss Super League")
        ]

checkAndPlaceOrder :: MarketCatalogue -> RWST (AppKey,Token) Log Manager IO ()
checkAndPlaceOrder mkt =
 showMarket mkt
   >> getMarketBook (marketId mkt)
   >>= (\mb -> if MarketBook.status mb == Just OPEN
                then order mkt mb
                else stdOutAndLog "not OPEN")

showMarket :: MarketCatalogue -> RWST (AppKey,Token) Log Manager IO ()
showMarket mkt =
 groomedLog mkt >> groomedLog mktSummary >> lift (putStr mktSummary)
 where mktSummary =
            unwords [ marketId mkt
                    , fromJustNote "showMarket" . marketStartTime $ mkt
                    , fromJustNote "showMarket: event name" . name
                       . fromJustNote "showMarket: event" . event $ mkt
                    , " "
                    ]

order :: MarketCatalogue -> MarketBook -> RWST (AppKey,Token) Log Manager IO ()
order mc mb =
 if noOrderInMarket mb then newOrder mc mb else checkOrder mc mb

type SelectionId = Integer
over15RunnerSelectionId :: MarketCatalogue -> SelectionId
over15RunnerSelectionId =
 RunnerCatalog.selectionId
    . headNote "over15RunnerSelectionId: "
    . filter ((==) "Over 1.5 Goals" . runnerName)
    . fromJustNote "over15RunnerSelectionId: "
    . MarketCatalogue.runners

over15RunnerBook :: MarketBook -> SelectionId -> Runner
over15RunnerBook mb s =
    headNote "over15RunnerBook: "
      . filter ((==) s . selectionId)
      . fromJustNote "over15RunnerBook: " . runners $ mb

newOrder :: MarketCatalogue -> MarketBook -> RWST (AppKey,Token) Log Manager IO ()
newOrder mc mb = lift (putStr " newOrder ") >> placingOrder mc mb

placingOrder :: MarketCatalogue -> MarketBook -> RWST (AppKey,Token) Log Manager IO ()
placingOrder mc mb = do
 let selid = over15RunnerSelectionId mc
     rbook = over15RunnerBook mb selid
     lprice = layPrice rbook
     mktid = marketId mc
 if Runner.status rbook /= ACTIVE
  then stdOutAndLog "runner not ACTIVE: "
  else if lprice > 1.39
        then stdOutAndLog "lay price > 1.39"
        else showMarketBook mb selid lprice
              >> lay mktid selid lprice (customerReference mc)
              -- discarding the Execution Report
              -- >>= putStrLn . groom
              >>= checkExecutionReport

checkExecutionReport :: PlaceExecutionReport -> RWST r Log Manager IO ()
checkExecutionReport (PlaceExecutionReport{PER.status = ERS.SUCCESS}) =
  stdOutAndLog " placed"
checkExecutionReport _ = stdOutAndLog " FAILED"

layPrice :: Runner -> Double
layPrice r =
 case ex r of
   Nothing -> 1.01
   Just ep -> case availableToBack ep of
                 Nothing -> 1.01
                 (Just []) -> 1.01
                 (Just (x:_)) -> price x

type CustomerRef = String
lay :: MarketId -> SelectionId -> Double -> CustomerRef
    -> RWST (AppKey,Token) Log Manager IO PlaceExecutionReport
lay mktid selId lprice custRef =
    placeOrder
        mktid
        PlaceInstruction { orderType = LIMIT
                         , PlaceInstruction.selectionId = selId
                         , handicap = Nothing
                         , side = LAY
                         , limitOrder =
                             Just $ LimitOrder betSize lprice LAPSE
                         , limitOnCloseOrder = Nothing
                         , marketOnCloseOrder = Nothing
                         }
        custRef

checkOrder :: MarketCatalogue -> MarketBook -> RWST (AppKey,Token) Log Manager IO ()
checkOrder mc mb
  | Runner.status rbook /= ACTIVE =
    stdOutAndLog "runner not ACTIVE: "
  | lprice > 1.39 = stdOutAndLog "lay price > 1.39"
  | [] == (ordersToCancel lprice . orders $ rbook) =
    stdOutAndLog "no ordersToCancel"
  | otherwise =
    (mapM_ (cancellingOrder mktid) . ordersToCancel lprice . orders $
      rbook)
      >> placingOrder mc mb
  where selid = over15RunnerSelectionId mc
        rbook = over15RunnerBook mb selid
        lprice = layPrice rbook
        mktid = marketId mc

cancellingOrder :: MarketId -> Order -> RWST (AppKey,Token) Log Manager IO ()
cancellingOrder mktid o =
    cancelOrder mktid
                (CancelInstruction (betId o) Nothing)
                (mktid ++ "cancel" ++ betId o)
     >>= checkCancelExecutionReport

checkCancelExecutionReport :: CancelExecutionReport
                           -> RWST (AppKey,Token) Log Manager IO ()
checkCancelExecutionReport (CancelExecutionReport{CER.status = ERS.SUCCESS}) =
    stdOutAndLog " cancelled"
checkCancelExecutionReport _ = stdOutAndLog " cancel FAILED"

ordersToCancel :: Double -> Maybe [Order] -> [Order]
ordersToCancel _ Nothing = []
ordersToCancel p (Just os)=
 betSizedOrders . buriedOrders p . executableOrders $ os
--    . fromJustNote "executableOrders"

betSizedOrders :: [Order] -> [Order]
betSizedOrders =
 filter ((==) betSize . fromJustNote "" . sizeRemaining)

buriedOrders :: Double -> [Order] -> [Order]
buriedOrders p = filter ((>) p . fromJustNote "" . Order.price)

executableOrders :: [Order] -> [Order]
executableOrders = filter ((==) EXECUTABLE . Order.status)

-- Optional parameter allowing the client to pass a unique string
--   (up to 32 chars) that is used to de-dupe mistaken re-submissions
-- CustomerRef can contain: upper/lower chars, digits,
--   chars : - . _ + * : ; ~ only.
customerReference :: MarketCatalogue -> String
customerReference mc =
 take 32 . filter (not . isSpace) . intercalate "-"
   $ [competitionName mc, mktId, selId]
 where mktId = marketId mc
       selId = show $ over15RunnerSelectionId mc
