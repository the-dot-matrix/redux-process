local function readglsl(pathto,file)
  local include = function(f) return readglsl(pathto,f) end
  local contents,_ = love.filesystem.read(pathto..file)
  if contents then
    contents = contents:gsub("#include \"(.-)\"", include)
  end
  return contents
end
local function loadglsl(code) return function()
    return love.graphics.newShader(code)
  end
end
local function errglsl(modname) return function(message)
    print(modname..": "..message)
    return false
  end
end
local function glsl(env)
  return function(modname)
    local p = modname:gsub("%.", "/"):gsub("%/glsl", ".glsl")
    if modname:find("glsl") and love.filesystem.getInfo(p) then
      return function(...)
        local last = 1
        while p:find("/",last+1) do last=p:find("/",last+1) end
        local pathto = p:sub(1,last)
        local file = p:sub(last+1)
        local code = readglsl(pathto,file)
        local _, result = xpcall(loadglsl(code),errglsl(p))
        return result
      end
    end
  end
end
table.insert(package.loaders, glsl(_G))
fennel = require("bin.fennel")
fennel.install({correlate=true})
fennel.dofile("trace.fnl")
fennel.dofile("wrap.fnl")
