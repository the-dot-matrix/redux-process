(import-macros {: Object : extends : new} :syntax.class)
(import-macros {: update : draw} :syntax.aGUI)
(extends Screen (Object))

(new Screen [! w h glsl sends]
  (set (!.w !.h) (values w h))
  (set !.canvas (love.graphics.newCanvas w h))
  (when glsl (set !.shader (require glsl)))
  (when sends (do (set !.sends sends) (!:update))))

(update Screen [! dt] [(and !.shader !.sends) #(!:send)])

(draw Screen [! todraw keep?]
  [true #(love.graphics.setCanvas !.canvas)]
  [(not keep?) #(love.graphics.clear 0 0 0 1)]
  [!.shader #(love.graphics.setShader !.shader)]
  [(= (type todraw) :userdata) #(love.graphics.draw todraw)]
  [(= (type todraw) :function) #(todraw)]
  [(not todraw) #(love.graphics.rectangle :fill 0 0 !.w !.h)]
  [true #(love.graphics.setShader)]
  [true #(love.graphics.setCanvas)])

(fn Screen.send [!]
  (when !.shader
    (each [k v (pairs !.sends)]
      (if (pcall #(unpack v))
          (when (unpack v) (!.shader:send k (unpack v)))
          (!.shader:send k v)))))

Screen
