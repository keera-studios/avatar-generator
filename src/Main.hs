-- To create a program that cna be invoked from CLI
import System.Environment
import System.Random
import System.IO
import System.Exit

-- Avatar generator
import AvatarGenerator

main :: IO ()
main = do
  args <- getArgs
  case args of
    [f] -> do gen  <- getStdGen
              let list      = randomRs (False, True) gen
                  (r:g:b:_) = randomRs (0, 255) gen
              avatarGenerator list (r,g,b) f

    _   -> do hPutStrLn stderr "usage: avatar-generator <output>"
              exitWith (ExitFailure 1)
