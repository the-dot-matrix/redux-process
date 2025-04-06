(local Error {})

(fn Error.load [!! oldmode errormessage errortrace]
  (love.graphics.setFont (love.graphics.newFont 16 :mono))
  (set Error.!! !!)
  (set Error.oldmode oldmode)
  (set Error.prettymsg (Error.color-msg errormessage))
  (set Error.prettytrace "")
  (each [v (errortrace:gmatch "[^\n]+")]
    (when (not (v:find "fennel.lua"))
      (set Error.prettytrace (.. Error.prettytrace v "\n")))))

(fn Error.draw [w h]
  (let [m "Press SPACE to reload last known safe state"]
    (love.graphics.setColor 0.34 0.61 0.86)
    (love.graphics.rectangle :fill 0 0 w h)
    (love.graphics.setColor 0.9 0.9 0.9)
    (love.graphics.printf   m             
                            (math.floor (* h 0.00))
                            (math.floor (* h 0.08)) 
                            w :center)
    (love.graphics.printf   Error.prettymsg 
                            (math.floor (* h 0.00))
                            (math.floor (* h 0.16)) 
                            w :center)
    (love.graphics.printf   Error.prettytrace 
                            (math.floor (* h 0.08))
                            (math.floor (* h 0.32)) 
                            w :left)))

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
