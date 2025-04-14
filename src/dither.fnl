(local Dither {})

(fn Dither.load [w h]
  (set Dither.shader (require :src.dither.glsl))
  (set Dither.canvas (love.graphics.newCanvas w h)))

Dither
