{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE NoImplicitPrelude    #-}
{-# LANGUAGE UndecidableInstances #-}

module MarketBook
   ( getMarketBook
   , showMarketBook
   , noOrderInMarket
   , getMarketBookOffersAndTraded
   , getMarketBookTraded
   ) where

import Control.Monad.RWS    (MonadTrans (lift), RWST)
import Data.Foldable        (all)
import Data.Maybe           (isNothing)
import Network.HTTP.Conduit (Manager)
import Safe                 (fromJustNote, headNote)

import Masked.Prelude hiding (log)

import Network.Betfair.Requests.ListMarketBook (marketBook)
import Network.Betfair.Requests.Log      (Log, log)
import Network.Betfair.Types.AppKey            (AppKey)
import Network.Betfair.Types.MarketBook        (MarketBook (runners))
import Network.Betfair.Types.PriceData         (PriceData (EX_ALL_OFFERS, EX_TRADED))
import Network.Betfair.Types.Runner            (Runner (orders))
import Network.Betfair.Types.Token             (Token)

type MarketId = String
getMarketBook :: MarketId -> RWST (AppKey,Token) Log Manager IO MarketBook
getMarketBook mktid =
 fmap (headNote "getMarketBook: No MarketBook")
      (marketBook mktid [EX_ALL_OFFERS])
--       (marketBook mktid EX_BEST_OFFERS t)

type SelectionId = Integer
showMarketBook :: MarketBook -> SelectionId -> Double -> RWST r Log Manager IO ()
showMarketBook _ selid lprice =
   lift (putStr (" at " ++ show lprice))
    >> log ("Placing order on " ++ show selid ++ " at " ++ show lprice)

noOrderInMarket :: MarketBook -> Bool
noOrderInMarket =
 all (isNothing . orders) . fromJustNote "noOrderinMarket: no Runners" . runners

getMarketBookOffersAndTraded :: MarketId
                    -> RWST (AppKey,Token) Log Manager IO MarketBook
getMarketBookOffersAndTraded mktid =
  fmap (headNote "getMarketBookOffersAndTraded: No MarketBook")
       (marketBook mktid [EX_ALL_OFFERS,EX_TRADED])

getMarketBookTraded :: MarketId -> RWST (AppKey,Token) Log Manager IO MarketBook
getMarketBookTraded mktid =
  fmap (headNote "getMarketBookTraded: No MarketBook")
       (marketBook mktid [EX_TRADED])
