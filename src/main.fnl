(local Main {})

(fn Main.load [!! w h]
  (set Main.scale 2)
  (love.graphics.setNewFont 32)
  (set Main.blank (require :src.blank))
  (Main.blank.load (/ w Main.scale) (/ h Main.scale))
  (set Main.fbm (require :src.fbm))
  (Main.fbm.load (/ w Main.scale) (/ h Main.scale))
  (set Main.dither (require :src.dither))
  (Main.dither.load (/ w Main.scale) (/ h Main.scale))
  (set Main.kmeans (require :src.kmeans))
  (Main.kmeans.load (/ w Main.scale) (/ h Main.scale)))

(fn Main.draw [w h]
  (love.graphics.setCanvas Main.blank.canvas)
  (love.graphics.clear 0 0 0 1)
  (love.graphics.setShader) ;Main.blank.shader
  (love.graphics.rectangle "fill" 0 0 (/ w Main.scale) 
                                      (/ h Main.scale))
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
  (love.graphics.scale Main.scale Main.scale)
  (love.graphics.draw Main.kmeans.canvas)
  (love.graphics.setShader)
  (love.graphics.setCanvas)

  (love.graphics.print (love.timer.getFPS)))

Main
