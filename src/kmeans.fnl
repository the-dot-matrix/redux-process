(import-macros {: extends : new} :mac.class)
(extends Kmeans (require :src.screen))

(new Kmeans [! w h :gpu.kmeans.glsl]
  (set !.K 12) ;TODO get K from shader?
  ;TODO send colors to shader, make relationship explicit
  (set !.colors [
    [0.50  0.00  0.00    0.2]
    [0.50  0.50  0.00    0.2]
    [0.00  0.50  0.00    0.2]
    [0.00  0.50  0.50    0.2]
    [0.00  0.00  0.50    0.2]
    [0.50  0.00  0.50    0.2]
    [0.50  0.30  0.00    0.2]
    [0.50  0.50  0.30    0.2]
    [0.00  0.50  0.30    0.2]
    [0.30  0.50  0.50    0.2]
    [0.30  0.00  0.50    0.2]
    [0.50  0.30  0.50    0.2]])
  (!:update w h))

; TODO clean-up anti-fenneled code below
; TODO imgdata is slow / colors are inaccurate, calc on CPU
(fn Kmeans.update [! w h]
  (if (and w h)
    (do
      (set !.centroids {})
      (for [k 1 !.K 1]
      (table.insert !.centroids [ (love.math.random 0 w)
                                  (love.math.random 0 h)])
      (set !.converged? false)))
    (when (not !.converged?) (do
      (local imgdata (!.canvas:newImageData))
      (set !.clusters {})
      (for [k 1 !.K] (table.insert !.clusters {:x 0 :y 0 :n 0}))
      (imgdata:mapPixel (partial Kmeans.cluster !))
      (!:centroid imgdata))))
  (!.super.update ! {:centroids !.centroids}))

(fn Kmeans.cluster [! x y r g b a]
  (each [k v (ipairs !.colors)]
    (local color (. !.colors k))
    (when (and (and (and (< (math.abs (- r (. color 1))) 0.05)
                         (< (math.abs (- g (. color 2))) 0.05))
                    (< (math.abs (- b (. color 3))) 0.05))
               (> a 0))
      (tset (. !.clusters k) :x (+ (. !.clusters k :x) x))
      (tset (. !.clusters k) :y (+ (. !.clusters k :y) y))
      (tset (. !.clusters k) :n (+ (. !.clusters k :n) 1))))
  (values r g b a))

(fn Kmeans.centroid [! imgdata]
  (var changed? false)
  (for [k 1 !.K]
    (local x (/ (. !.clusters k :x) (. !.clusters k :n)))
    (local y (/ (. !.clusters k :y) (. !.clusters k :n)))
    (local recentroid [(math.floor x) (math.floor y)])
    (set changed? (or changed?
      (or (not= (. !.centroids k 1) (. recentroid 1))
          (not= (. !.centroids k 2) (. recentroid 2)))))
    (tset !.centroids k recentroid))
  (set !.converged? (not changed?)))

Kmeans
