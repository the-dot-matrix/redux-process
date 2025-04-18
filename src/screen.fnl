(import-macros {: Object : extends : new : update} :mac.class)
(extends Screen (Object))
(new Screen [! w h glsl sends]
  (set !.canvas (love.graphics.newCanvas w h))
  (when glsl (set !.shader (require glsl)))
  (when sends (Screen.update ! sends)))

(update Screen [! sends]
  [!.shader :src.screen :send !.uuid sends])

(fn Screen.draw [! drawable]
  (love.graphics.setCanvas !.canvas)
  (love.graphics.clear 0 0 0 1)
  (when !.shader (love.graphics.setShader !.shader))
  (drawable)
  (love.graphics.setShader)
  (love.graphics.setCanvas))

(fn Screen.send [! sends]
  (when !.shader (each [key value (pairs sends)]
    (if (pcall #(unpack value))
        (!.shader:send key (unpack value))
        (!.shader:send key value)))))

Screen
