(local Main {})

(fn love.load [] 
  (love.graphics.setNewFont 64)
  (love.graphics.setDefaultFilter :nearest :nearest)
  (let [(w h) (love.window.getDesktopDimensions)]
    (love.window.setMode w h {:fullscreen true :vsync false})
    (Main.load :src.main w h)))

(fn love.update [dt]
  (Main.safely Main.mode.update dt))

(fn love.draw []
  (love.graphics.clear)
  (let [(w h) (love.graphics.getDimensions)]
    (Main.safely Main.mode.draw w h)
    (Main.safely Main.draw w h)))

(fn Main.load [new ...]
  (set (Main.mode Main.name) (values (require new) new))
  (each [e _ (pairs love.handlers)]
    (let [modef (if (. Main.mode e) (. Main.mode e) #$)
          safef #(Main.safely modef $...)
          wrapf #(do (Main.keypressed $...) (safef $...))
          handler (if (= e :keypressed) wrapf safef)]
      (tset love.handlers e handler)))
  (Main.safely Main.mode.load Main.load ...))

(fn Main.draw [w h]
  (var newlines "")
  (let [fps   {:fps (love.timer.getFPS)}
        infos [(love.graphics.getRendererInfo)]
        info  (accumulate [c "" i v (ipairs infos)] (.. c v))
        name  {:name (. infos 1)}
        vers  {:version (. infos 2)}
        vend  {:vendor (. infos 3)}
        dev   {:device (. infos 4)}
        views [info fps]]
    (each [i v (ipairs views)]
      (love.graphics.print (.. newlines (fennel.view v)))
      (set newlines (.. newlines "\n")))))

(fn Main.keypressed [key]
  (when (= key :escape) (love.event.quit)))

(fn Main.safely [f ...]
  (when f (let [ferr (fennel.traceback) lerr (debug.traceback)]
    (xpcall f #(Main.load :trace Main.name $ ferr lerr) ...))))
