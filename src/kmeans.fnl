(import-macros {: extends : new} :mac.class)
(extends Kmeans (require :src.screen))

(new Kmeans [! w h :gpu.kmeans.glsl]
  (set !.K 12) ;TODO get K from shader?
  ;TODO send colors to shader, make relationship explicit
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
  (!:update w h))

(fn Kmeans.update [! w h]
  (set !.centroids {})
  (for [k 1 !.K 1] (table.insert !.centroids 
    [(love.math.random 0 w) (love.math.random 0 h)]))
  (!.super.update ! {:centroids !.centroids}))

Kmeans
