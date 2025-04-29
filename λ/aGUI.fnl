(fn update [c vs & body] `(fn
  ,(sym (.. (tostring c) :.update)) ,vs
  ,(unpack (icollect [_ v (ipairs body)]
    (let [(cond then a b c d e f) (unpack v)]
      `(when ,cond (,then)))))))

(fn draw [c vs & body] `(fn
  ,(sym (.. (tostring c) :.draw)) ,vs
  ,(unpack (icollect [_ v (ipairs body)]
    (let [(cond then a b c d e f) (unpack v)]
      `(when ,cond (,then)))))))

{: update : draw}
