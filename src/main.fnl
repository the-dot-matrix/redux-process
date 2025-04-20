(import-macros {: Object : extends : new : update} :mac.class)
(extends Main (Object))
(local Blank  (require :src.blank))
(local FBM    (require :src.fbm))
(local Dither (require :src.dither))
(local Kmeans (require :src.kmeans))

(new Main [! !! w h]
  (set (!.w !.h !.scale) (values w h 4))
  (let [(sw sh) (values (/ !.w !.scale) (/ !.h !.scale))]
    (set !.blank (Blank:new sw sh))
    (set !.fbm (FBM:new sw sh))
    (set !.dither (Dither:new sw sh))
    (set !.kmeans (Kmeans:new sw sh)))
  (set !.drawn? false)
  (set !.done? false))

(update Main [! dt]
  [(and !.drawn? (not !.iter?))
    #(!.kmeans:update !.dither.canvas)]
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
    (set (!.drawn? !.iter? !.done?)
      (values false false false))))
  (when (= key :rshift) (error (fennel.traceback))))

Main
