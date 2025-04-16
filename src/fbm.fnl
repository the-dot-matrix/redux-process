(import-macros {: extends : new} :mac.class)
(extends FBM (require :src.screen))
(new FBM [! w h :gpu.fbm.glsl {
    :scale 0.25 :height 1 :exponentiation 2
    :octaves 1 :lacunarity 1 :persistence 0}])

(fn FBM.update [!]
  (!.super.update ! {
    :offsetx (love.math.random -55555 55555)
    :offsety (love.math.random -55555 55555)}))

FBM
