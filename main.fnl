(fn love.load [] )

(fn love.draw []
  (love.graphics.print "Hello!\nPress escape to quit" 10 10))

(fn love.keypressed [key]
  (when (= key "escape") (love.event.quit)))
