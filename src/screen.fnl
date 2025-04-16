(import-macros {: Object : extends : new} :mac.class)
(extends Screen (Object))
(new Screen [! w h glsl send]
  (when glsl (set !.shader (require glsl))
    (when send (each [key value (pairs send)]
      (!.shader:send key (unpack value)))))
  (set !.canvas (love.graphics.newCanvas w h)))

(fn Screen.draw [! drawable]
  (love.graphics.setCanvas !.canvas)
  (love.graphics.clear 0 0 0 1)
  (when !.shader (love.graphics.setShader !.shader))
  (drawable)
  (love.graphics.setShader)
  (love.graphics.setCanvas))

Screen
