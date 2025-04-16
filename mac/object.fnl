(local Object {})
(set Object.__index Object)

(fn Object.new [!] {})

(fn Object.extend [!]
  (local class {})
  (set (class.__index class.super) (values class !))
  (setmetatable class !)
  class)

Object
