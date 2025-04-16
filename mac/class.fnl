(fn Object [] `(require :mac.object))

(fn extends [a b]
  `(local ,(sym (tostring a)) ((. ,b :extend) ,b)))

(fn new [c vs & body]
  `(fn ,(sym (.. (tostring c) :.new)) ,vs
      (local ,(sym (tostring (. vs 1)))
        (setmetatable
          ( ,(sym (.. (tostring c) :.super.new)) ,(unpack vs))
            ,(sym (tostring (. vs 1)))))
      (do ,(unpack body))
      ,(sym (tostring (. vs 1)))))

{: Object : extends : new}
