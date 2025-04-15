; (local Object {})
; (set Object.__index Object)

; (fn Object.new [!])

; (fn Object.extend [!]
;   (local cls {})
;   (each [k v (pairs !)]
;     (when (= (k:find "__") 1) (= (. cls k) v)
; function Object:extend()
;   local cls = {}
;   for k, v in pairs(self) do
;     if k:find("__") == 1 then
;       cls[k] = v
;     end
;   end
;   cls.__index = cls
;   cls.super = self
;   setmetatable(cls, self)
;   return cls
; end



; Object
