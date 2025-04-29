(import-macros {: Object : extends : new} :λ.class)
(import-macros {: update : draw} :λ.aGUI)
(extends Screen (Object))

(new Screen [! w h glsl sends]
  (set !.canvas (love.graphics.newCanvas w h))
  (when glsl (set !.shader (require glsl)))
  (when sends (do (set !.sends sends) (!:update))))

(update Screen [! dt] [(and !.shader !.sends) #(!:send)])

(draw Screen [! drawable]
  [true #(love.graphics.setCanvas !.canvas)]
  [true #(love.graphics.clear 0 0 0 1)]
  [!.shader #(love.graphics.setShader !.shader)]
  [drawable #(love.graphics.draw drawable)]
  [(not drawable) #(love.graphics.clear 1 1 1 1)]
  [true #(love.graphics.setShader)]
  [true #(love.graphics.setCanvas)])

(fn Screen.send [!]
  (when !.shader
    (each [k v (pairs !.sends)]
      (if (pcall #(unpack v))
          (when (unpack v) (!.shader:send k (unpack v)))
          (!.shader:send k v)))))

Screen
