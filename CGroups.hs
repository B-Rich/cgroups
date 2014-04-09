module Main where

import Conduit
import Control.Monad
import Data.Maybe (fromMaybe)
import Data.Text (Text, pack)
import Filesystem
import Filesystem.Path.CurrentOS hiding (encode)
import Network.HTTP.Types.Status
import Network.Socket
import Network.Wai.Handler.FastCGI
import Prelude hiding (FilePath, log)
import Web.Scotty as Scotty hiding (body)

-- Write a FastCGI program (preferably in Haskell) that provides a restful API
-- to manage the cgroups of a server.  It should support the following:
--
--  - list available cgroups
--  - list the tasks (PIDs) for a given cgroup
--  - place a process into a cgroup
--
-- You can assume that the server is running a Linux 3.4 kernel with the
-- cgroup root mounted via sysfs.  Include a default.nix to build your program
-- as a nix package.  Bonus points for including a NixOS module.nix.

main :: IO ()
main = withSocketsDo $ scottyApp cgroups >>= run

cgroups :: ScottyM ()
cgroups = do
    --  - list available cgroups
    get "/list" $ do
        cgs <- liftIO $ runResourceT $
            sourceDirectoryDeep False cgdir
                -- Only return cgroups that have tasks
                $= filterC (\x -> filename x == "tasks")
                $= mapC ( pack
                        . stripTrailing '/'
                        . encodeString
                        . directory
                        . (\x -> fromMaybe x $ stripPrefix cgdir x)
                        )
                $$ sinkList
        json cgs

    --  - list the tasks (PIDs) for a given cgroup
    get "/tasks/:cgroup" $ do
        cg <- param "cgroup"
        withCGroup cg $ \tasksFile -> do
            tasks <- liftIO $ runResourceT $
                sourceFile tasksFile
                    $= linesUnboundedC
                    $$ sinkList
            json (tasks :: [Text])

    --  - place a process into a cgroup
    get "/register/:cgroup/:pid" $ do
        cg  <- param "cgroup"
        pid <- param "pid"
        withCGroup cg $ \tasksFile -> do
            dirExists <- liftIO $ isDirectory ("/proc" </> decodeString pid)
            if dirExists
                then do
                    liftIO $ runResourceT $
                        yield pid $$ sinkFile tasksFile
                    json ()
                else status notFound404
  where
    cgdir = "/sys/fs/cgroup/"

    stripTrailing :: Char -> String -> String
    stripTrailing _ [] = []
    stripTrailing c [y]
        | c == y    = []
        | otherwise = [y]
    stripTrailing c (x:xs) = x:stripTrailing c xs

    withCGroup :: String -> (FilePath -> ActionM ()) -> ActionM ()
    withCGroup cg go = do
        let dir       = cgdir </> decodeString cg
            tasksFile = dir </> "tasks"
        dirExists <- liftIO $ isDirectory dir
        if dirExists
            then do
                fileExists <- liftIO $ isFile tasksFile
                if fileExists
                    then go tasksFile
                    else status notFound404
            else status notFound404
