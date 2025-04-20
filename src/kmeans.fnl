(import-macros {: extends : new : update} :mac.class)
(extends Kmeans (require :src.screen))

;TODO get K from shader?
(new Kmeans [! w h :gpu.kmeans.glsl] (set !.K 12))

(update Kmeans [! canvas]
  [canvas #(!:init canvas)]
  [(and (not canvas) (not !.converged?)) #(!:iter)]
  [true #(!.super.update ! {:centroids !.centroids})])

(fn Kmeans.init [! canvas]
  (set !.points [])
  (local pixels (canvas:newImageData))
  (pixels:mapPixel (partial Kmeans.pixel2point !))
  (set !.centroids {})
  ;; TODO only rand points?
  (for [k 1 !.K 1] (table.insert !.centroids
    [ (love.math.random 0 (canvas:getWidth))
      (love.math.random 0 (canvas:getHeight))]))
  (set !.converged? false))

(fn Kmeans.pixel2point [! x y r g b a]
  (when (= (+ r b g a) 4) (table.insert !.points [x y]))
  (values r g b a))

(fn Kmeans.iter [!]
  (set !.clusters {})
  (for [k 1 !.K] (table.insert !.clusters {:x 0 :y 0 :n 0}))
  (for [i 1 (length !.points)]
    (local p (. !.points i))
    (local k (!:cluster p))
    (set (. !.clusters k :x) (+ (. !.clusters k :x) (. p 1)))
    (set (. !.clusters k :y) (+ (. !.clusters k :y) (. p 2)))
    (set (. !.clusters k :n) (+ (. !.clusters k :n) 1)))
  (!:centroid))

(fn Kmeans.cluster [! p]
  (var mindist nil)
  (var cluster nil)
  (for [k 1 !.K]
    (local dist (!:distance p (. !.centroids k)))
    (when (or (not mindist) (< dist mindist)) (do
      (set mindist dist)
      (set cluster k))))
  cluster)

(fn Kmeans.distance [! p1 p2]
  (local a (math.abs (- (. p1 1) (. p2 1))))
  (local b (math.abs (- (. p1 2) (. p2 2))))
  (math.sqrt (+ (math.pow a 2) (math.pow b 2))))

(fn Kmeans.centroid [!]
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
