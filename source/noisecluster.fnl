(import-macros {: Object : extends : new} :syntax.class)
(import-macros {: update : draw} :syntax.aGUI)
(extends NoiseCluster (Object))
(local Blank  (require :source.screen.blank))
(local FBM    (require :source.screen.fbm))
(local Dither (require :source.screen.dither))
(local Kmeans (require :source.screen.kmeans))

(new NoiseCluster [! !! w h]
  (set !.scale 4)
  (set (!.w !.h) (values (/ w !.scale) (/ h !.scale)))
  (set !.blank (Blank:new !.w !.h))
  (set !.fbm (FBM:new !.w !.h))
  (set !.dither (Dither:new !.w !.h))
  (set !.kmeans (Kmeans:new !.w !.h !.dither.canvas)))

(update NoiseCluster [! dt]
  [(not !.done?) #(set !.done? (!.kmeans:update))])

; TODO redraws back, who should handle? draw call optimization
(draw NoiseCluster [!]
  [true #(!.blank:draw)]
  [true #(!.fbm:draw !.blank.canvas)]
  [true #(!.dither:draw !.fbm.canvas)]
  [true #(!.kmeans:draw !.dither.canvas)]
  [true #(love.graphics.scale !.scale !.scale)]
  [true #(love.graphics.draw !.kmeans.canvas)])

(fn NoiseCluster.keypressed [! key] ;TODO better UI
  (when (= key :space) (do
    (!.fbm:update)
    (set !.kmeans (Kmeans:new !.w !.h !.dither.canvas))
    (set !.done? false))))

NoiseCluster
