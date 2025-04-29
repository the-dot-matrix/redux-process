(import-macros {: Object : extends : new} :λ.class)
(import-macros {: update : draw} :λ.aGUI)
(extends Main (Object))
(local Blank  (require :src.blank))
(local FBM    (require :src.fbm))
(local Dither (require :src.dither))
(local Kmeans (require :src.kmeans))

(new Main [! !! w h]
  (set !.scale 4)
  (set (!.w !.h) (values (/ w !.scale) (/ h !.scale)))
  (set !.blank (Blank:new !.w !.h))
  (set !.fbm (FBM:new !.w !.h))
  (set !.dither (Dither:new !.w !.h))
  (set !.kmeans (Kmeans:new !.w !.h !.dither.canvas)))

(update Main [! dt]
  [(not !.done?) #(set !.done? (!.kmeans:update))])

; TODO redraws back, who should handle? draw call optimization
(draw Main [!]
  [true #(!.blank:draw)]
  [true #(!.fbm:draw !.blank.canvas)]
  [true #(!.dither:draw !.fbm.canvas)]
  [true #(!.kmeans:draw !.dither.canvas)]
  [true #(love.graphics.scale !.scale !.scale)]
  [true #(love.graphics.draw !.kmeans.canvas)])

(fn Main.keypressed [! key] ;TODO better UI
  (when (= key :space) (do
    (!.fbm:update)
    (set !.kmeans (Kmeans:new !.w !.h !.dither.canvas))
    (set !.done? false)))
  (when (= key :rshift) (error (fennel.traceback))))

Main
