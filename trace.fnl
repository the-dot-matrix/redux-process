(local Error {})

; TODO cleanup, better traces, deeper embedding of tracebacks
(fn Error.load [!! oldmode errormessage fnltrace luatrace]
  (love.graphics.setFont (love.graphics.newFont 32 :mono))
  (set Error.!! !!)
  (set Error.oldmode oldmode)
  (set Error.prettymsg (Error.color-msg errormessage))
  (set Error.fnltrace "")
  (set Error.luatrace "")
  (each [v (fnltrace:gmatch "[^\n]+")]
    (set Error.fnltrace (.. Error.fnltrace v "\n")))
  (each [v (luatrace:gmatch "[^\n]+")]
    (set Error.luatrace (.. Error.luatrace v "\n"))))

(fn Error.draw [w h]
  (let [m "Press SPACE to reload last known safe state"]
    (love.graphics.setColor 0.34 0.61 0.86)
    (love.graphics.rectangle :fill 0 0 w h)
    (love.graphics.setColor 0.9 0.9 0.9)
    (love.graphics.printf   m
                            (math.floor (* h 0.00))
                            (math.floor (* h 0.02))
                            w :center)
    (love.graphics.printf   Error.prettymsg
                            (math.floor (* h 0.00))
                            (math.floor (* h 0.08))
                            w :center)
    (love.graphics.printf   Error.fnltrace
                            (math.floor (* h 0.04))
                            (math.floor (* h 0.16))
                            w :left)
    (love.graphics.printf   Error.luatrace
                            (math.floor (* h -0.04))
                            (math.floor (* h 0.16))
                            w :right)))

(fn Error.keypressed [key scancode repeat]
  (match key :space (Error.!! Error.oldmode)))

(fn Error.color-msg [msg]
  (if msg
    (case (msg:match "(.*)\027%[7m(.*)\027%[0m(.*)")
      (pre selected post)
      [ [1 1 1] pre
        [1 0.2 0.2] selected
        [1 1 1] post]
      _ msg)
    ""))

Error
