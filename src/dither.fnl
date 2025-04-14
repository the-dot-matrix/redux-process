(local Dither {})

(fn Dither.load [!!]
  (set Dither.shader (require :src.dither.glsl))
  (set Dither.canvas (love.graphics.newCanvas 320 160)))

Dither
