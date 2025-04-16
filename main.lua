local readglsl
readglsl = function(pathto,file)
  local include = function(f) return readglsl(pathto,f) end
  local contents,_ = love.filesystem.read(pathto..file)
  contents = contents:gsub("#include \"(.-)\"", include)
  return contents
end
local glsl = function(env)
  return function(modname)
    local p = modname:gsub("%.", "/"):gsub("%/glsl", ".glsl")
    if modname:find("glsl") and love.filesystem.getInfo(p) then
      return function(...)
        local slashes = {p:find("/")}
        local pathto = p:sub(1,slashes[#slashes])
        local file = p:sub(slashes[#slashes]+1)
        return love.graphics.newShader(readglsl(pathto,file))
      end
    end
  end
end
table.insert(package.loaders, glsl(_G))
fennel = require("bin.fennel")
fennel.install().dofile("wrap.fnl")
