(fn Object [] `{})

(fn extends [a b] 
  `(do
    (local ,a {})
    (set ((. ,a :__index) (. ,a :super)) (values ,a ,b))
    ,a))

; TODO generate generic parts of new
(fn new [c args & body]
  `(fn ,c ,args (do ,(unpack body))))

{: Object : extends : new}
