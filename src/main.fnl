(import-macros {: Object : extends : new : update} :mac.class)
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
  [(and !.drawn? (not !.iter?)) #(!.kmeans:update)]
  [(and !.iter? (not !.done?)) #(!.kmeans:update)])

(fn Main.draw [! w h] ;TODO better pipeline
  (when (not !.drawn?) (do
      (!.blank:draw #(love.graphics.rectangle
        "fill" 0 0 (/ w !.scale) (/ h !.scale)))
      (!.fbm:draw #(love.graphics.draw !.blank.canvas))
      (!.dither:draw #(love.graphics.draw !.fbm.canvas))))
  (when (not !.done?) (do
    (!.kmeans:draw #(love.graphics.draw !.dither.canvas))))
  (love.graphics.scale !.scale !.scale)
  (love.graphics.draw !.kmeans.canvas)
  (!:step)) ;TODO avoid state update in draw call

(fn Main.step [!]
  (when (and !.iter? (not !.done?))
    (set !.done? !.kmeans.converged?))
  (when (and !.drawn? (not !.iter?)) (set !.iter? true))
  (when (not !.drawn?) (set !.drawn? true)))

(fn Main.keypressed [! key] ;TODO better UI
  (when (= key :space) (do
    (!.fbm:update)
    (set !.kmeans (Kmeans:new !.w !.h !.dither.canvas))
    (set (!.drawn? !.iter? !.done?)
      (values false false false))))
  (when (= key :rshift) (error (fennel.traceback))))

Main
