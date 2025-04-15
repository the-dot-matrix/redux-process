(import-macros {: Object : extends : new} :mac.class)
(local Blank (extends Blank (require :src.screen)))

; TODO replace with macro
(fn Blank.new [! w h]
  (setmetatable {} !)
  (!.super:new w h))

Blank
