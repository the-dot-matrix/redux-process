GUI = require("gui")
KMEANS = require("kmeans")
local width,height = love.graphics.getDimensions()
local dither
local allwhite,fbmnoise,dithered,kmeansed

function loadshader(filename)
	local contents, _ = love.filesystem.read(filename)
	contents = contents:gsub("#include \"(.-)\"", loadshader)
	return contents
end
function love.load(args, unfilteredArgs) 
	width,height=love.window.getDesktopDimensions()
	love.window.setMode(width,height)
	love.graphics.setDefaultFilter("nearest","nearest")
    love.graphics.setNewFont(32)
    GUI.shader = love.graphics.newShader(loadshader("fbm.glsl"))
    dither = love.graphics.newShader(loadshader("dither.glsl"))
    GUI.init()
    allwhite = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    fbmnoise = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    dithered = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    kmeansed = love.graphics.newCanvas(GUI.config.tilex+GUI.config.border,GUI.config.tiley+GUI.config.border)
end

function love.update(dt)
	if GUI.drawn then
		if not KMEANS.converged then
			KMEANS.iter(kmeansed:newImageData(nil,nil,0,0,kmeansed:getWidth(),kmeansed:getHeight()))
		end
	else
		KMEANS.init(dithered:getWidth(),dithered:getHeight())
	end
end
function love.draw()
	if not GUI.drawn then
		love.graphics.setCanvas(allwhite)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,GUI.config.tilex,GUI.config.tiley)
		
		love.graphics.setCanvas(fbmnoise)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader(GUI.shader)
		love.graphics.draw(allwhite)

		love.graphics.setCanvas(dithered)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader(dither)
		love.graphics.draw(fbmnoise)

		GUI.drawn = true
	end

	love.graphics.setCanvas(kmeansed)
	love.graphics.clear(0,0,0,1)
	love.graphics.setShader(KMEANS.shader)
	love.graphics.draw(dithered,GUI.config.border/2,GUI.config.border/2)
	
	love.graphics.setColor(1,1,1,1)
	love.graphics.setCanvas()
	love.graphics.setShader()
	love.graphics.clear(0.25,0.25,0.25,1)
	love.graphics.push()
	love.graphics.translate((width-kmeansed:getWidth()*GUI.config.tilepx)/2,(height-kmeansed:getHeight()*GUI.config.tilepx)/2)
	love.graphics.scale(GUI.config.tilepx,GUI.config.tilepx)
	love.graphics.draw(kmeansed)
	love.graphics.pop()
	love.graphics.setColor(0,0,0,GUI.config.a)
	love.graphics.rectangle("fill",0,0,GUI.config.w,GUI.config.h)
	local fps = love.timer.getFPS()
	if fps<99 then love.graphics.setColor(0.11,0.99,0.11,GUI.config.a) end
	if fps<60 then love.graphics.setColor(0.99,0.99,0.11,GUI.config.a) end
	if fps<30 then love.graphics.setColor(0.99,0.11,0.11,GUI.config.a) end
	love.graphics.print("FPS:"..fps)
	local f = function(text,height) 
		love.graphics.setColor(0.44,0.44,0.44,GUI.config.a)
		if GUI.mouse.hovering and GUI.mouse.hovering[1]==text[1] then love.graphics.setColor(0.66,0.66,0.66,GUI.config.a) end
		if GUI.mouse.adjusting and GUI.mouse.adjusting[1]==text[1] then love.graphics.setColor(0.88,0.88,0.88,GUI.config.a) end
		love.graphics.draw(text[2],0,height) 
	end
	local fa = function(text,accum) return math.max(accum,text[2]:getWidth()) end
	GUI.config.h,GUI.config.w = GUI.visit(f, fa)
	love.graphics.setColor(1,1,1,1)
end
