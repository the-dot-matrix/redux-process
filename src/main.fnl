(local Main {})

(fn Main.load [!!]
  (love.graphics.setNewFont 48)
  (set Main.blank (require :src.blank))
  (Main.blank.load)
  (set Main.fbm (require :src.fbm))
  (Main.fbm.load)
  (set Main.dither (require :src.dither))
  (Main.dither.load)
  (set Main.kmeans (require :src.kmeans))
  (Main.kmeans.load))

(fn Main.draw [w h]
  (love.graphics.setCanvas Main.blank.canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader) ;Main.blank.shader
  (love.graphics.rectangle "fill" 0 0 320 160)
  (love.graphics.setShader)
  (love.graphics.setCanvas)
  
  (love.graphics.setCanvas Main.fbm.canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader Main.fbm.shader)
  (love.graphics.draw Main.blank.canvas)
  (love.graphics.setShader)
  (love.graphics.setCanvas)  
  
  (love.graphics.setCanvas Main.dither.canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader Main.dither.shader)
  (love.graphics.draw Main.fbm.canvas)
  (love.graphics.setShader)
  (love.graphics.setCanvas)

  (love.graphics.setCanvas Main.kmeans.canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader Main.kmeans.shader)
  (love.graphics.draw Main.dither.canvas)
  (love.graphics.setShader)
  (love.graphics.setCanvas)
  
  (love.graphics.setCanvas) ;default screen
  (love.graphics.clear 0.25 0.25 0.25 1)
  (love.graphics.setShader) ;default shader
  (love.graphics.draw Main.kmeans.canvas)
  (love.graphics.setShader)
  (love.graphics.setCanvas))

Main
