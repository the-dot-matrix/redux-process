(import-macros {: Object : extends : new} :mac.class)
(local Kmeans (extends Kmeans (require :src.screen)))

; TODO replace with macro
(fn Kmeans.new [! w h]
  (local self {})
  (setmetatable self !)
  (set self.K 12)
  (set self.colors [
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
  (set self.converged false)
  (set self.centroids {})
  (for [k 1 self.K 1]
    (table.insert self.centroids [(love.math.random 0 w)
                                  (love.math.random 0 h)]))
  (!.super:new w h :src.kmeans.glsl
    {:centroids self.centroids}))

Kmeans
