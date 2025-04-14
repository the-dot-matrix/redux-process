(local fennel (require :lib.fennel))
(var (mode name) nil)
(local Main {})

(fn love.load [] 
  (let [(w h) (love.window.getDesktopDimensions)]
    (love.window.setMode w h {:fullscreen true}))
  (love.graphics.setNewFont 64)
  (love.graphics.setDefaultFilter :nearest :nearest)
  (Main.load :main))

(fn love.update [dt]
  (when mode.update (Main.safely mode.update dt)))

(fn love.draw []
  (love.graphics.clear)
  (let [(w h) (love.graphics.getDimensions)]
    (when mode.draw (Main.safely mode.draw w h))))

(fn Main.load [new ...]
  (set (mode name) (values (require (.. :src. new)) new))
  (each [e _ (pairs love.handlers)]
    (let [modef (if (. mode e) (. mode e) #$)
          safef #(Main.safely modef $...)
          wrapf #(do (Main.keypressed $...) (safef $...))
          handler (if (= e :keypressed) wrapf safef)]
      (tset love.handlers e handler)))
  (when mode.load (Main.safely mode.load Main.load ...)))

(fn Main.keypressed [key]
  (when (= key :escape) (love.event.quit)))

(fn Main.safely [f ...]
  (let [ftrace (fennel.traceback)
        ltrace (debug.traceback)]
    (xpcall f #(Main.load :error name $ ftrace ltrace) ...)))
