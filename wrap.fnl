(local exit? #(and (= $1 :keypressed) (= $2 :escape)))
(var (mode file) (values nil nil))

(fn love.run []
  (let [args (love.arg.parseGameArguments arg)]
    (when love.load (love.load args arg)))
  (when love.timer (love.timer.step))
  (var dt 0)
  (fn []
    (when love.event (love.event.pump)
      (each [event a b c d e f (love.event.poll)]
        (when (or (= event :quit) (exit? event a))
          (when (or (not love.quit) (not (love.quit)))
            (let [exitcode (or a 0)] (lua "return exitcode"))))
        (when (. mode event)
          ((. mode event) a b c d e f))))
    (when love.timer (set dt (love.timer.step)))
    (when love.update (love.update dt))
    (when (and love.graphics (love.graphics.isActive))
      (love.graphics.origin)
      (love.graphics.clear (love.graphics.getBackgroundColor))
      (when love.draw (love.draw))
      (love.graphics.setCanvas)
      (love.graphics.present))
    (when love.timer (love.timer.sleep 0.001))))

(fn love.load [args raws]
  (love.graphics.setDefaultFilter :nearest :nearest)
  (let [(w h) (love.window.getDesktopDimensions)]
    (love.window.setMode w h {:fullscreen true :vsync false})
    (set (mode file) (values (require :src.main) :src.main))
    (mode.load load w h)))

(fn love.update [dt] (mode.update dt))

(fn love.draw []
  (love.graphics.clear)
  (let [(w h) (love.graphics.getDimensions)]
    (mode.draw w h))
    ; TODO move this out of here
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
