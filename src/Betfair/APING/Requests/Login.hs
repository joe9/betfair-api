{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Betfair.APING.Requests.Login
  (sessionToken
  ,login)
  where

import           BasicPrelude            hiding (error, null)
import           Control.Exception.Safe
import qualified Data.ByteString.Lazy    as L (ByteString)
import           Data.String.Conversions
import           Data.Text
import           Network.HTTP.Conduit
--
import Betfair.APING.API.Context
import Betfair.APING.API.GetResponse
import Betfair.APING.API.Headers     (headers)
import Betfair.APING.Types.AppKey    (AppKey)
import Betfair.APING.Types.Login
import Betfair.APING.Types.Token     (Token)

-- http://stackoverflow.com/questions/3232074/what-is-the-best-way-to-convert-string-to-bytestring
encodeBody
  :: AppKey -> Text -> Text -> Request -> Request
encodeBody appKey username password req =
  urlEncodedBody [("username",cs username),("password",cs password)]
                 req {requestHeaders = headers appKey Nothing}

-- Note that loginRequest uses a url encoded body unlike other
--   requests (which are json objects)
loginRequest
  :: Context -> Text -> Text -> IO Request
loginRequest context username password =
  fmap (encodeBody (cAppKey context)
                   username
                   password)
       (parseUrlThrow "https://identitysso.betfair.com/api/login")

sessionToken
  ::  Context -> Text -> Text -> IO Token
sessionToken context username password =
  either throwM pure =<<
  fmap parseLogin . getDecodedResponse context =<<
  loginRequest context username password

parseLogin :: Login -> Either LoginError Token
parseLogin l
  | null (token l) = Left (toLoginError l)
  | otherwise = Right (token l)

login
  :: Context -> Text -> Text -> IO (Response L.ByteString)
login c u p = getResponse c =<< loginRequest c u p
