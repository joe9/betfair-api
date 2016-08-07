{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Network.Betfair.Requests.Login
  (sessionToken
  ,login
  ,JsonRequest(..))
  where

import           BasicPrelude         hiding (error)
import           Data.Aeson
import           Data.Aeson.TH
import qualified Data.ByteString.Lazy as L (ByteString)
import           Data.Either.Utils
import           Network.HTTP.Conduit

import Network.Betfair.Requests.Context
import Network.Betfair.Requests.GetResponse
import Network.Betfair.Requests.Headers           (headers)
import Network.Betfair.Requests.ResponseException
import Network.Betfair.Types.Login
import Network.Betfair.Types.Token                (Token)

data JsonRequest =
  JsonRequest {username :: Text
              ,password :: Text}
  deriving (Eq,Show)

$(deriveJSON defaultOptions {omitNothingFields = True}
             ''JsonRequest)

loginRequest
  :: Context -> Text -> Text -> IO Request
loginRequest c u p =
  fmap (\req ->
          req {requestHeaders = headers (cAppKey c) Nothing
              ,method = "POST"
              ,requestBody = RequestBodyLBS (encode (JsonRequest u p))}) $
  parseUrlThrow "https://identitysso.betfair.com/api/login"

sessionToken
  :: Context -> Text -> Text -> IO (Either ResponseException Token)
sessionToken c u p =
  fmap parseLogin . getDecodedResponse c =<< loginRequest c u p

parseLogin
  :: Either ResponseException Login -> Either ResponseException Token
parseLogin (Left e) = Left e
parseLogin (Right l) =
  maybeToEither
    (LoginError (l {errorDescription = (lookup (error l) loginExceptionCodes)}))
    (token l)

login
  :: Context -> Text -> Text -> IO (Response L.ByteString)
login c u p = getResponse c =<< loginRequest c u p
