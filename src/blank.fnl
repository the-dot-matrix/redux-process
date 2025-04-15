(import-macros {: Object : extends : new} :mac.class)
(local Blank (extends Blank (require :src.screen)))

; TODO fix super constructor chaining
;(new Blank [! w h])
(fn Blank.new [! w h] (!.super:new w h))

Blank
