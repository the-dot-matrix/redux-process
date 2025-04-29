(import-macros {: extends : new} :λ.class)
(import-macros {: update} :λ.aGUI)
(extends Kmeans (require :src.screen))

(new Kmeans [! w h :src.kmeans.glsl false input]
  (let [firstline ((love.filesystem.lines :src/kmeans.glsl))]
    (set !.K (tonumber ((firstline:gmatch "K = (%d+);")))))
  (set !.input input)
  (set !.points [])
  (set !.centroids {}))

(update Kmeans [! dt]
  [(= (length !.centroids) 0) #(!:init)]
  [(not !.converged?) #(!:iter)]
  [true #(set !.super.sends {:centroids !.centroids})]
  [true #(!.super.update ! dt)]
  [true (hashfn !.converged?)])

(fn Kmeans.init [!]
  (let [pixels (!.input:newImageData)]
    (pixels:mapPixel (partial Kmeans.pixel2point !)))
  (for [k 1 !.K 1] (table.insert !.centroids
    (. !.points (love.math.random 1 (length !.points)))))
  (set !.converged? false))

(fn Kmeans.pixel2point [! x y r g b a]
  (when (= (+ r b g a) 4) (table.insert !.points [x y]))
  (values r g b a))

(fn Kmeans.iter [!]
  (set !.clusters {})
  (for [k 1 !.K] (table.insert !.clusters {:x 0 :y 0 :n 0}))
  (for [i 1 (length !.points)]
    (let [p (. !.points i) k (!:cluster p)]
      (set (. !.clusters k) { :x (+ (. !.clusters k :x) (. p 1))
                              :y (+ (. !.clusters k :y) (. p 2))
                              :n (+ (. !.clusters k :n) 1)})))
  (!:centroid))

(fn Kmeans.cluster [! p]
  (var (mindist cluster) (values nil nil))
  (for [k 1 (length !.centroids)]
    (let [dist (!:distance p (. !.centroids k))]
      (when (or (not mindist) (< dist mindist))
        (do (set mindist dist) (set cluster k)))))
  cluster)

(fn Kmeans.distance [! p1 p2]
  (let [a (math.abs (- (. p1 1) (. p2 1)))
        b (math.abs (- (. p1 2) (. p2 2)))]
    (math.sqrt (+ (math.pow a 2) (math.pow b 2)))))

(fn Kmeans.centroid [!]
  (var changed? (= (length !.centroids) 0))
  (for [k 1 (length !.centroids)]
    (let [x (/ (. !.clusters k :x) (. !.clusters k :n))
          y (/ (. !.clusters k :y) (. !.clusters k :n))
          recentroid [(math.floor x) (math.floor y)]
          xchange (not= (. !.centroids k 1) (. recentroid 1))
          ychange (not= (. !.centroids k 2) (. recentroid 2))]
      (set changed? (or changed? xchange ychange))
      (tset !.centroids k recentroid)))
  (set !.converged? (not changed?)))

Kmeans
