{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.API.GetResponse
  (
  getDecodedResponse

  )
  where

import                   Betfair.APING.Requests.Logout
import                   Betfair.APING.Requests.ListMarketBook
import                   Betfair.APING.Requests.ListMarketCatalogue
import                   Betfair.APING.Requests.CancelOrders
import                   Betfair.APING.Requests.PlaceOrders
import                   Betfair.APING.Requests.Login
import                   Betfair.APING.Requests.KeepAlive
import                   Betfair.APING.API.GetResponse
import                   Betfair.APING.API.WriterLog
import                   Betfair.APING.API.ResponseException
import                   Betfair.APING.API.Context
import                   Betfair.APING.API.Headers
import                   Betfair.APING.API.APIRequest
