module Main where

import Graphics.Gloss
-- main = animate (InWindow "My Window" (200, 200) (10, 10)) white (\t -> ThickCircle (80 + 10*sin t) 10)
-- main = animate (InWindow "My Window" (200, 200) (10, 10)) white (\t -> Arc 0 60 (80 + 10*sin t))
main = animate (InWindow "My Window" (200, 200) (10, 10)) white (\t -> ThickArc 30 120 (80 + 10*sin t) (10 + 5*sin t))