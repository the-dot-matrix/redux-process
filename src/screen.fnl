(import-macros {: Object : extends : new : update} :mac.class)
(extends Screen (Object))
(new Screen [! w h glsl sends]
  (set !.canvas (love.graphics.newCanvas w h))
  (when glsl (set !.shader (require glsl)))
  (when sends (do (set !.sends sends) (!:update))))

(update Screen [! dt] [(and !.shader !.sends) #(!:send)])

(fn Screen.draw [! drawable]
  (love.graphics.setCanvas !.canvas)
  (love.graphics.clear 0 0 0 1)
  (when !.shader (love.graphics.setShader !.shader))
  (drawable)
  (love.graphics.setShader)
  (love.graphics.setCanvas))

(fn Screen.send [!]
  (each [k v (pairs !.sends)]
    (if (pcall #(unpack v))
        (!.shader:send k (unpack v))
        (!.shader:send k v))))

Screen
