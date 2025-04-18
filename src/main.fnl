(import-macros {: Object : extends : new : update} :mac.class)
(extends Main (Object))
(local Blank  (require :src.blank))
(local FBM    (require :src.fbm))
(local Dither (require :src.dither))
(local Kmeans (require :src.kmeans))

(new Main [! !! w h]
  (set (!.w !.h !.scale) (values w h 8))
  (let [(sw sh) (values (/ w !.scale) (/ h !.scale))]
    (set !.blank (Blank:new sw sh))
    (set !.fbm (FBM:new sw sh))
    (set !.dither (Dither:new sw sh))
    (set !.kmeans (Kmeans:new sw sh)))
  (set !.drawn? false)
  (set !.done? false))

(update Main [! dt] [!.drawn? #(!.kmeans.update !.kmeans)])

(fn Main.draw [! w h]
  (when (not !.drawn?) ;TODO better pipeline
    (do
      (!.blank:draw #(love.graphics.rectangle
        "fill" 0 0 (/ w !.scale) (/ h !.scale)))
      (!.fbm:draw #(love.graphics.draw !.blank.canvas))
      (!.dither:draw #(love.graphics.draw !.fbm.canvas))
      (love.event.push :src.main :step !.uuid)))
  (when (not !.done?) (do
    (!.kmeans:draw #(love.graphics.draw !.dither.canvas))
    (love.event.push :src.main :step !.uuid)))
  (love.graphics.scale !.scale !.scale)
  (love.graphics.draw !.kmeans.canvas))

(fn Main.step [!]
  (when (not !.drawn?) (set !.drawn? true))
  (when (and !.drawn? (not !.done?))
    (set !.done? !.kmeans.converged?)))

(fn Main.keypressed [! key] ;TODO better UI
  (when (= key :space)
    (do (!.fbm:update)
        (!.kmeans:update (/ !.w !.scale)
                            (/ !.h !.scale))
        (set (!.drawn? !.done?) (values false false))))
  (when (= key :rshift) (error (fennel.traceback))))

Main
