(local FBM {})

(fn FBM.load [!!]
  (set FBM.shader (require :src.fbm.glsl))
  (set FBM.sends {
    :scale 0.25 :height 1 :exponentiation 2
    :octaves 1 :lacunarity 1 :persistence 0
    :offsetx (love.math.random -55555 55555)
    :offsety (love.math.random -55555 55555)})
  (each [key value (pairs FBM.sends)]
    (FBM.shader:send key value))
  (set FBM.canvas (love.graphics.newCanvas 320 160)))

FBM
