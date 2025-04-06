fennel = require("fennel")
lfs = love.filesystem
debug.traceback = fennel.traceback
table.insert(package.loaders, function(f)
   if lfs.getInfo(f) then
      return function(...)
         return fennel.eval(lfs.read(f),{env=_G,f=f},...),f
      end
   end
end)
require("main.fnl")
