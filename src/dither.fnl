(import-macros {: extends : new} :mac.class)
(extends Dither (require :src.screen))

; TODO replace with macro
(fn Dither.new [! w h]
  (setmetatable {} !)
  (!.super:new w h :gpu.dither.glsl))

Dither
