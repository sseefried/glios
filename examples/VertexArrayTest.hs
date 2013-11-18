module Main where

import Graphics.Rendering.OpenGL.Raw
import Graphics.Rendering.OpenGL as GL
import Foreign.Storable
import Data.Array.Storable
import Data.Array.MArray
import Foreign.C
import Foreign

foreign import ccall gliosGetWindowWidth     :: CInt
foreign import ccall gliosGetWindowHeight    :: CInt
foreign import ccall gliosSetDisplayCallback :: FunPtr (IO ()) -> IO ()
foreign import ccall gliosInit               :: IO ()
foreign import ccall safe gliosMainLoop      :: IO ()
foreign import ccall gliosDraw               :: IO ()
foreign import ccall "wrapper" mkFunPtr      :: IO () -> IO (FunPtr (IO ()))
foreign import ccall gliosLog                :: CString -> IO ()


backendLog :: String -> IO ()
backendLog s = do
  cstr <- newCString s
  gliosLog cstr

main :: IO ()
main = do
  gliosInit
  ptr <- mkFunPtr display
  gliosSetDisplayCallback ptr
  gliosMainLoop

renderCircleLine :: Float -> Float -> Int -> Float -> IO ()
renderCircleLine posX posY steps rad =
  let n                = fromIntegral steps
      tStep            = (2 * pi) / n
      tStop            = (2 * pi)
      c                = fromRational . toRational
      ptOnCircle tt = [ c (posX + rad * cos tt), c (posY + rad * sin tt) ]
      circleLineSteps :: Float -> [GL.GLfloat]
      circleLineSteps tt
        | tt >= tStop = []
        | otherwise = circleLineSteps (tt + tStep) ++ ptOnCircle tt
      vertices = circleLineSteps 0
  in do GL.color $ GL.Color4 1 0 0 (1 :: GL.GLfloat)
        a <- newListArray (0,length vertices - 1) vertices
        GL.clientState GL.VertexArray GL.$= GL.Enabled
        withStorableArray (a :: StorableArray Int GL.GLfloat) $ \ptr -> do
          GL.arrayPointer GL.VertexArray GL.$= GL.VertexArrayDescriptor
                                                 2
                                                 GL.Float
                                                 0
                                                 ptr
        backendLog (show vertices)
        GL.drawArrays GL.LineLoop 0 (fromIntegral steps)
        GL.clientState GL.VertexArray GL.$= GL.Disabled

display :: IO ()
display = do
  clear [ColorBuffer, DepthBuffer]
--  GL.matrixMode $= Projection
--  GL.loadIdentity
  GL.preservingMatrix $ do
    GL.loadIdentity
    let h = fromIntegral gliosGetWindowHeight
    let w = fromIntegral gliosGetWindowWidth
    glOrthof (-w/2) (w/2) (-h/2) (h/2) (-1) 1
--    GL.matrixMode   $= GL.Modelview 0
    renderCircleLine 0 0 64 50
--    GL.matrixMode $= Projection
  flush
  return ()