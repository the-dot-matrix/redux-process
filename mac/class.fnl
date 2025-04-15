(fn Object [] `{:new (fn [!#] !#)})

(fn extends [a b] `(do
  (local ,a {})
  (set ((. ,a :__index) (. ,a :super)) (values ,a ,b))
  (setmetatable ,a ,b)
  ,a))

; TODO fix super constructor chaining
(fn new [c args & body]
  `(fn ,(sym (.. (tostring c) :.new)) ,args
      (local ,(sym (tostring (. args 1)))
              (setmetatable {} (. ,args 1)))
      (do ,(unpack body))
      (,(sym (.. (tostring (. args 1)) ".super.new"))
        (unpack ,args))
      ,(sym (tostring (. args 1)))))

{: Object : extends : new}
