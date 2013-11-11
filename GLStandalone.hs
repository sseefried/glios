module Main where

import Foreign
import Foreign.C

foreign import ccall safe "glsa" glsa :: IO ()

main = do
  putStrLn "Haskell started"
  glsa