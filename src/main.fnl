(local Main {})
(import-macros {: incf } :mac.math)
(set Main.shader (require :src.fbm))

(fn Main.load [!!]
  (love.graphics.setNewFont 48)
  (set Main.test 0)
  (set Main.!! !!)
  (set Main.sends {
    :scale 0.25 :height 1 :exponentiation 2
    :octaves 1 :lacunarity 1 :persistence 0
    :offsetx (love.math.random -55555 55555)
    :offsety (love.math.random -55555 55555)})
  (each [key value (pairs Main.sends)]
    (Main.shader:send key value))
  (set Main.allwhite (love.graphics.newCanvas 320 160))
  (set Main.fbmnoise (love.graphics.newCanvas 320 160)))

(fn Main.tester [] (if (> Main.test 100) (error)))
(fn Main.update [dt]
  (incf Main.test)
  (Main.tester))

(fn Main.draw [w h]
  (love.graphics.setCanvas Main.allwhite)
  (love.graphics.rectangle "fill" 0 0 320 160)
  (love.graphics.setCanvas Main.fbmnoise)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader Main.shader)
  (love.graphics.draw Main.allwhite)
  (love.graphics.setShader)
  (love.graphics.setCanvas)
  (love.graphics.clear 0.25 0.25 0.25 1)
  (love.graphics.draw Main.fbmnoise)
  (love.graphics.print Main.test))

Main
