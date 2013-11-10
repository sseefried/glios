module Main where

import Foreign
import Foreign.C

foreign import ccall safe "glsa" glsa :: CString -> IO ()

main = do
  putStrLn "Haskell started"
  msg <- newCString "Motherfucka!"
  glsa msg