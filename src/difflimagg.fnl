(import-macros {: Object : extends : new} :λ.class)
(import-macros {: update : draw} :λ.aGUI)
(extends DiffusionLimitedAggregation (Object))
(local Grid (require :src.screen.grid))

(new DiffusionLimitedAggregation [! !! w h]
  (set (!.tilepx !.numtiles) (values 32 16))
  (set !.scale (/ h (* !.tilepx !.numtiles)))
  (set !.w (+ (math.floor (/ h !.scale)) 1))
  (set !.h (+ (math.floor (/ h !.scale)) 1))
  (set !.pixelperfect (math.floor !.scale))
  (set !.centerx (/ (- w (* !.w !.pixelperfect)) 2))
  (set !.centery (/ (- h (* !.pixelperfect !.h)) 2))
  (set !.grid (Grid:new !.w !.h {:tpx !.tilepx})))

(update DiffusionLimitedAggregation [! dt])

(draw DiffusionLimitedAggregation [!]
  [true #(!.grid:draw)]
  [true #(love.graphics.translate !.centerx !.centery)]
  [true #(love.graphics.scale !.pixelperfect !.pixelperfect)]
  [true #(love.graphics.draw !.grid.canvas)])

(fn DiffusionLimitedAggregation.keypressed [! key]
  (when (= key :space) (do)))

DiffusionLimitedAggregation
