(fn Object [] `(require :λ.object))

(fn extends [a b]
  `(local ,(sym (tostring a)) ((. ,b :extend) ,b)))

(fn new [c vs & body] `(fn
  ,(sym (.. (tostring c) :.new))
  ,(icollect [_ v (ipairs vs)] (when (sym? v) v))
  (local ,(sym (tostring (. vs 1)))
    (setmetatable
      ( ,(sym (.. (tostring c) :.super.new)) ,(unpack vs))
        ,(sym (tostring (. vs 1)))))
  (do ,(unpack body))
  ,(sym (tostring (. vs 1)))))

{: Object : extends : new}
