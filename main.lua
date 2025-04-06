local instal = {correlate=true, moduleName="lib.fennel"}
fennel = require("lib.fennel").install(instal)
debug.traceback = fennel.traceback
local search = function(env) 
  return function(module_name)
    local path = module_name:gsub("%.", "/") .. ".fnl"
    if love.filesystem.getInfo(path) then
      return function(...)
        local code = love.filesystem.read(path)
        return fennel.eval(code, {env=env, filename=path}, ...)
      end, path
    end
  end
end
local searcher = function(env) return search(env) end
table.insert(package.loaders, searcher(_G))
table.insert(fennel["macro-searchers"], searcher("_COMPILER"))
search(_G)("main")()
