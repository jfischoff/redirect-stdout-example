module Main where
import System.Posix.Process (forkProcess)
import System.Posix.IO      (createFile, dupTo, stdOutput, stdError)
import System.Posix.Files   (accessModes)
import Control.Monad        (forever, void)
import Control.Concurrent   (threadDelay)
import System.Posix.Signals
import Control.Exception

runServer :: IO ()
runServer = forever $ do
  threadDelay 1000000
  putStrLn "hello?"

main :: IO ()
main
  = bracket
      (forkProcess $ do
         newStdout <- createFile "stdout.txt" accessModes
         dupTo newStdout stdOutput

         newStderr <- createFile "stderr.txt" accessModes
         dupTo newStderr stdError

         runServer
      )
      (signalProcess sigKILL)
      $ \_ -> void $ getLine
