(local Main {})
(local Blank  (require :src.blank))
(local FBM    (require :src.fbm))
(local Dither (require :src.dither))
(local Kmeans (require :src.kmeans))

(fn Main.load [!! w h]
  (set (Main.w Main.h Main.scale) (values w h 8))
  (love.graphics.setNewFont (/ 64 Main.scale))
  (let [(sw sh) (values (/ w Main.scale) (/ h Main.scale))]
    (set Main.blank (Blank:new sw sh))
    (set Main.fbm (FBM:new sw sh))
    (set Main.dither (Dither:new sw sh))
    (set Main.kmeans (Kmeans:new sw sh)))
  (set Main.drawn? false)
  (set Main.done? false))

(fn Main.update [dt] (when Main.drawn? (Main.kmeans:update)))

(fn Main.draw [w h]
  (when (not Main.drawn?) ;TODO better pipeline
    (do
      (Main.blank:draw #(love.graphics.rectangle
        "fill" 0 0 (/ w Main.scale) (/ h Main.scale)))
      (Main.fbm:draw #(love.graphics.draw Main.blank.canvas))
      (Main.dither:draw #(love.graphics.draw Main.fbm.canvas))
      (set Main.drawn? true)))
  (when (not Main.done?) (do
    (Main.kmeans:draw #(love.graphics.draw Main.dither.canvas))
    (set Main.done? Main.kmeans.converged?)))
  (love.graphics.scale Main.scale Main.scale)
  (love.graphics.draw Main.kmeans.canvas))

(fn Main.keypressed [key] ;TODO better UI
  (when (= key :space)
    (do (Main.fbm:update)
        (Main.kmeans:update (/ Main.w Main.scale)
                            (/ Main.h Main.scale))
        (set (Main.drawn? Main.done?) (values false false)))))

Main
