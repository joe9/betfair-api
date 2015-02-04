{-# OPTIONS_GHC -Wall #-}

module Network.Betfair.Requests.Login
   ( sessionToken
   , login
   ) where

import           Control.Monad.RWS                    (MonadTrans (lift),
                                                       RWST)
import qualified Data.ByteString.Lazy                 as L (ByteString)
import           Network.HTTP.Conduit                 (Manager, Request (requestHeaders),
                                                       Response,
                                                       parseUrl,
                                                       urlEncodedBody)

import           Network.Betfair.Requests.Config      (Config (..))
import           Network.Betfair.Requests.GetResponse (getResponse, getResponseBodyString)
import           Network.Betfair.Requests.Headers     (bs, headers)
import           Network.Betfair.Requests.ParseLogin  (getToken)
import           Network.Betfair.Requests.WriterLog   (Log)
import           Network.Betfair.Types.Token          (Token)

loginRequest :: Config -> IO Request
loginRequest c =
  fmap (encodeBody c)
    $ parseUrl "https://identitysso.betfair.com/api/login"

-- http://stackoverflow.com/questions/3232074/what-is-the-best-way-to-convert-string-to-bytestring
encodeBody :: Config -> Request -> Request
encodeBody c req =
  urlEncodedBody [ (bs "username", bs u)
                 , (bs "password", bs p)
                 ]
                 req {requestHeaders = headers a Nothing}
  where u = username c
        p = password c
        a = appKey   c

sessionToken :: Config -> RWST r Log Manager IO Token
sessionToken c =
 fmap getToken . getResponseBodyString =<< lift (loginRequest c)

login :: Config -> RWST r Log Manager IO (Response L.ByteString)
login c = getResponse =<< lift (loginRequest c)
