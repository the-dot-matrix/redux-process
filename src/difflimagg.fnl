(import-macros {: Object : extends : new} :λ.class)
(import-macros {: update : draw} :λ.aGUI)
(extends DiffusionLimitedAggregation (Object))
(local Grid (require :src.screen.grid))
(local DLA (require :src.screen.dla))

(new DiffusionLimitedAggregation [! !! w h]
  (set !.tilepx 32)
  (set !.numtiles (+ (math.floor (/ !.tilepx 2)) 1))
  (set !.scale (/ h (* !.tilepx !.numtiles)))
  (set !.w (+ (math.floor (/ h !.scale)) 1))
  (set !.h (+ (math.floor (/ h !.scale)) 1))
  (set !.pixelperfect (math.floor !.scale))
  (set !.centerx (/ (- w (* !.w !.pixelperfect)) 2))
  (set !.centery (/ (- h (* !.pixelperfect !.h)) 2))
  (set !.grid (Grid:new !.w !.h {:tpx !.tilepx}))
  (set !.dla (DLA:new !.w !.h !.tilepx))
  (set !.first? true))

(update DiffusionLimitedAggregation [! dt]
  [(not !.init?) #(set !.init? true)]
  [!.first? #(set !.init? false)]
  [!.first? #(set !.first? false)])

(draw DiffusionLimitedAggregation [!]
  [(not !.init?) #(!.grid:draw)]
  [true #(!.dla:draw)]
  [true #(love.graphics.translate !.centerx !.centery)]
  [true #(love.graphics.scale !.pixelperfect !.pixelperfect)]
  [true #(love.graphics.draw !.grid.canvas)]
  [true #(love.graphics.setBlendMode :alpha :premultiplied)]
  [true #(love.graphics.draw !.dla.canvas)]
  [true #(love.graphics.setBlendMode :alpha)])

(fn DiffusionLimitedAggregation.keypressed [! key]
  (when (= key :space) (do)))

DiffusionLimitedAggregation
