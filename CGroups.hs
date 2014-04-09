module Main where

import           Control.Monad.IO.Class
import           Data.Text
import qualified Data.Text.Lazy as TL
import           Network.Socket
import           Network.Wai
import           Network.Wai.Handler.FastCGI
import           Prelude hiding (log)
import           Web.Scotty

main :: IO ()
main = withSocketsDo $ scottyApp cgroups >>= run

cgroups :: ScottyM ()
cgroups = do
    get "/list" $ json ["foo" :: Text, "bar", "baz"]
    matchAny (regex ".*") $ do
        hdrs <- headers
        liftIO $ putStrLn $ "Headers: " ++ show hdrs
        req <- request
        html $ TL.pack
             $ "<p>Didn't understand: " ++ show (pathInfo req) ++ "</p>\n"
            ++ "<p>Didn't understand: " ++ show (rawPathInfo req) ++ "</p>"
