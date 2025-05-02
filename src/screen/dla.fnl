(import-macros {: extends : new} :λ.class)
(import-macros {: update : draw} :λ.aGUI)
(extends DLA (require :src.screen))
(new DLA [! w h false false cellpx]
  (set !.cellpx cellpx)
  (set !.first? true))

(update DLA [!]
  [(not !.init?) #(set !.init? true)]
  [!.first? #(set !.init? false)]
  [!.first? #(set !.first? false)])

(draw DLA [!]
  [(not !.init?) #(!:drawcell (/ !.w 2) (/ !.h 2) !.cellpx)])

(fn DLA.drawcell [! x y s]
  (let [(t l) (values (- y (/ s 2)) (- x (/ s 2)))
        cellf #(love.graphics.rectangle :fill l t s s)]
    (!.super.draw ! cellf true)))

DLA
