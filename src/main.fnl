(local Main {})

(fn Main.load [!!]
  (set Main.!! !!)
  (set Main.sends {
    :scale 0.25 :height 1 :exponentiation 2
    :octaves 1 :lacunarity 1 :persistence 0
    :offsetx (love.math.random -55555 55555)
    :offsety (love.math.random -55555 55555)})
  (set Main.pixelcode (Main.loadshader "fbm.glsl"))
  (set Main.shader (love.graphics.newShader Main.pixelcode))
  (each [key value (pairs Main.sends)]
    (Main.shader:send key value))
  (set Main.allwhite (love.graphics.newCanvas 320 160))
  (set Main.fbmnoise (love.graphics.newCanvas 320 160)))

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
  (love.graphics.draw Main.fbmnoise))

(fn Main.loadshader [filename]
  (let [(contents _) (love.filesystem.read (.. :src/ filename))]
    (contents:gsub "#include \"(.-)\"" Main.loadshader)))

Main
