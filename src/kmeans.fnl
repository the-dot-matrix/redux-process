(local Kmeans {})

(fn Kmeans.load [!!]
  (set Kmeans.shader (require :src.kmeans.glsl))
  (set Kmeans.sends {})
  (each [key value (pairs Kmeans.sends)]
    (Kmeans.shader:send key value))
  (set Kmeans.canvas (love.graphics.newCanvas 320 160)))

Kmeans
