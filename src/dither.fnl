(import-macros {: Object : extends : new} :mac.class)
(local Dither (extends Dither (require :src.screen)))

; TODO replace with macro
(fn Dither.new [! w h]
  (setmetatable {} !)
  (!.super:new w h :src.dither.glsl))

Dither
