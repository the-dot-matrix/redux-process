(import-macros {: extends : new} :λ.class)
(import-macros {: update} :λ.aGUI)
(extends FBM (require :src.screen))
(new FBM [! w h :src.shader.fbm.glsl {
    :scale 0.25 :height 1 :exponentiation 2
    :octaves 1 :lacunarity 1 :persistence 0}]
  (!:update))

(update FBM [! dt] [true #(!:random)])

(fn FBM.random [!]
  (set !.sends.offsetx (love.math.random -55555 55555))
  (set !.sends.offsety (love.math.random -55555 55555))
  (!.super.update !))

FBM
