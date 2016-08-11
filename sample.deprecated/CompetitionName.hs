{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE UndecidableInstances #-}

module CompetitionName
   ( competitionName
   ) where

import           Safe                                  (fromJustNote)

import           Network.Betfair.Types.Competition     (Competition (name))
import           Network.Betfair.Types.MarketCatalogue (MarketCatalogue (competition))

competitionName :: MarketCatalogue -> String
competitionName = name . fromJustNote "competitionName: " . competition
