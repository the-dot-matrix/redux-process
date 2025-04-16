(import-macros {: extends : new} :mac.class)
(extends Kmeans (require :src.screen))

(new Kmeans [! w h :gpu.kmeans.glsl {:centroids !.centroids}]
  (set !.K 12)
  (set !.colors [
    [0.50  0.00  0.00    0.5]
    [0.50  0.50  0.00    0.5]
    [0.00  0.50  0.00    0.5]
    [0.00  0.50  0.50    0.5]
    [0.00  0.00  0.50    0.5]
    [0.50  0.00  0.50    0.5]
    [0.50  0.25  0.00    0.5]
    [0.50  0.50  0.25    0.5]
    [0.00  0.50  0.25    0.5]
    [0.25  0.50  0.50    0.5]
    [0.25  0.00  0.50    0.5]
    [0.50  0.25  0.50    0.5]])
  (set !.converged false)
  (set !.centroids {})
  (for [k 1 !.K 1]
    (table.insert !.centroids [(love.math.random 0 w)
                                  (love.math.random 0 h)])))

Kmeans
