(import-macros {: Object : extends : new} :mac.class)
(extends Screen (Object))
(new Screen [! w h glsl sends]
  (when glsl (set !.shader (require glsl)))
  (when sends (Screen.update ! sends))
  (set !.canvas (love.graphics.newCanvas w h)))

(fn Screen.update [! sends]
  (when !.shader (each [key value (pairs sends)]
    (!.shader:send key value))))

(fn Screen.draw [! drawable]
  (love.graphics.setCanvas !.canvas)
  (love.graphics.clear 0 0 0 1)
  (when !.shader (love.graphics.setShader !.shader))
  (drawable)
  (love.graphics.setShader)
  (love.graphics.setCanvas))

Screen
