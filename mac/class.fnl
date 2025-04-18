(fn Object [] `(require :lib.classic))

(fn extends [a b]
  `(local ,(sym (tostring a)) ((. ,b :extend) ,b)))

(fn new [c vs & body] `(fn
  ,(sym (.. (tostring c) :.new))
  ,(icollect [_ v (ipairs vs)] (when (sym? v) v))
  (local ,(sym (tostring (. vs 1)))
    (setmetatable
      ( ,(sym (.. (tostring c) :.super.new)) ,(unpack vs))
        ,(sym (tostring (. vs 1)))))
  (tset ,(sym (tostring (. vs 1))) :uuid (. _G :uuid))
  (tset (. _G :uuids) (. _G :uuid) ,(sym (tostring (. vs 1))))
  (do ,(unpack body))
  ,(sym (tostring (. vs 1)))))

(fn update [c vs & body] `(fn
  ,(sym (.. (tostring c) :.update)) ,vs
  ,(unpack (icollect [_ v (ipairs body)]
    (let [(cond then a b c d e f) (unpack v)]
      `(when ,cond (if
          (not (string.find ,(tostring then) :.update))
          (love.event.push ,(tostring then) ,a ,b ,c ,d ,e ,f)
          (,then))))))))

{: Object : extends : new : update}
