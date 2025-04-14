(local Kmeans {})

(fn Kmeans.load [w h]
  (set Kmeans.shader (require :src.kmeans.glsl))
  (set Kmeans.canvas (love.graphics.newCanvas w h))
  (set Kmeans.K 12)
  (set Kmeans.colors [
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
  (set Kmeans.converged false)
  (set Kmeans.centroids {})
  (for [k 1 Kmeans.K 1]
    (table.insert Kmeans.centroids [(love.math.random 0 w) 
                                    (love.math.random 0 h)]))
  (Kmeans.shader:send :centroids (unpack Kmeans.centroids)))

Kmeans
