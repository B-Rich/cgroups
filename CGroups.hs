module Main where

import           Control.Monad.Trans.Class
import           Data.Text
import qualified Data.Text.Lazy as TL
import           Network.Wai
import           Network.Wai.Handler.FastCGI
import           Prelude hiding (log)
import           Web.Scotty

main :: IO ()
main = scottyApp cgroups >>= run

cgroups :: ScottyM ()
cgroups = do
    get "/list" $ json ["foo" :: Text, "bar", "baz"]
    matchAny (regex ".*") $ do
        hdrs <- headers
        lift $ putStrLn $ "Headers: " ++ show hdrs
        req <- request
        html $ TL.pack $ "<p>Didn't understand route: " ++ show (pathInfo req) ++ "</p>\n"
            ++ "<p>Didn't understand route: " ++ show (rawPathInfo req) ++ "</p>"
