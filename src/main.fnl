(local Main {})
(local Blank  (require :src.blank))
(local FBM    (require :src.fbm))
(local Dither (require :src.dither))
(local Kmeans (require :src.kmeans))

(fn Main.load [!! w h]
  (set Main.scale 4)
  (love.graphics.setNewFont (/ 64 Main.scale))
  (let [(sw sh) (values (/ w Main.scale) (/ h Main.scale))]
    (set Main.blank (Blank:new sw sh))
    (set Main.fbm (FBM:new sw sh))
    (set Main.dither (Dither:new sw sh))
    (set Main.kmeans (Kmeans:new sw sh))))

(fn Main.draw [w h]
  (Main.blank:draw #(love.graphics.rectangle
    "fill" 0 0 (/ w Main.scale) (/ h Main.scale)))
  (Main.fbm:draw #(love.graphics.draw Main.blank.canvas))
  (Main.dither:draw #(love.graphics.draw Main.fbm.canvas))
  (Main.kmeans:draw #(love.graphics.draw Main.dither.canvas))
  (love.graphics.scale Main.scale Main.scale)
  (love.graphics.draw Main.kmeans.canvas))

(fn Main.keypressed [key]
  (when (= key :space) (Main.fbm:update)))

Main
