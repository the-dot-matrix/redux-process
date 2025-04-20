(local Object {})
(set Object.__index Object)

(fn Object.new [!] {})

(fn Object.extend [!]
  (let [class {}]
    (each [k v (pairs !)]
      (when (= (k:find "__") 1) (tset class k v)))
    (set class.__index class)
    (set class.super !)
    (setmetatable class !)
    class))

(fn Object.implement [! ...]
  (each [_ class (pairs [...])]
    (each [k v (pairs class)]
      (when (and (= (. ! k) nil) (= (type v) :function))
        (tset ! k v)))))

(fn Object.is [! T]
  (var mt (getmetatable !))
  (while (and mt (not= mt T)) (set mt (getmetatable mt)))
  (= mt T))

Object
