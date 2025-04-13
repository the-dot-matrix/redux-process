local find = function(sf,env)
  return sf(env) 
end
local readglsl
readglsl = function(pathto,file)
  local include = function(f) return readglsl(pathto,f) end
  local contents,_ = love.filesystem.read(pathto..file)
  contents = contents:gsub("#include \"(.-)\"", include)
  return contents
end
local glsl = function(env) 
  return function(modname)
    local path = modname:gsub("%.", "/") .. ".glsl"
    if love.filesystem.getInfo(path) then
      return function(...)
        local slashes = {path:find("/")}
        local pathto = path:sub(1,slashes[#slashes])
        local file = path:sub(slashes[#slashes]+1)
        return love.graphics.newShader(readglsl(pathto,file))
      end
    end
  end
end
table.insert(package.loaders, find(glsl,_G))
local instal = {correlate=true, moduleName="lib.fennel"}
fennel = require("lib.fennel").install(instal)
debug.traceback = fennel.traceback
local fnl = function(env) 
  return function(modname)
    local path = modname:gsub("%.", "/") .. ".fnl"
    if love.filesystem.getInfo(path) then
      return function(...)
        local code = love.filesystem.read(path)
        return fennel.eval(code, {env=env, filename=path, correlate=true}, ...)
      end, path
    end
  end
end
table.insert(package.loaders, 1, find(fnl,_G))
table.insert(fennel["macro-searchers"], find(fnl,"_COMPILER"))
find(fnl,_G)("wrap")()
