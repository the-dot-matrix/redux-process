GUI = require("gui")
require("kmeans")
local width,height = love.graphics.getDimensions()
local dither
local texture,todither,dithered,screen

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
    texture = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    todither = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    dithered = love.graphics.newCanvas(GUI.config.tilex,GUI.config.tiley)
    screen = love.graphics.newCanvas(GUI.config.tilex+GUI.config.border,GUI.config.tiley+GUI.config.border)
end

function love.update(dt)
	if GUI.drawn and not clustering then
		image2points(dithered:newImageData(nil,nil,0,0,dithered:getWidth(),dithered:getHeight()))
		clustering = true
	else
		clustering = GUI.drawn
	end
	if clustering and not converged then
		kmeans_iter()
	else
		converged = not clustering
	end
end

function love.draw()
	if not GUI.drawn then
		love.graphics.setCanvas(texture)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,GUI.config.tilex,GUI.config.tiley)
		
		love.graphics.setCanvas(todither)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader(GUI.shader)
		love.graphics.draw(texture)

		love.graphics.setCanvas(dithered)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader(dither)
		love.graphics.draw(todither)
		
		love.graphics.setCanvas(screen)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader()
		love.graphics.draw(dithered,GUI.config.border/2,GUI.config.border/2)

		love.graphics.setCanvas()
		love.graphics.setColor(1,1,1,1)
		GUI.drawn = true
	end
	love.graphics.clear(0.25,0.25,0.25,1)
	love.graphics.push()
	love.graphics.translate((width-screen:getWidth()*GUI.config.tilepx)/2,(height-screen:getHeight()*GUI.config.tilepx)/2)
	love.graphics.scale(GUI.config.tilepx,GUI.config.tilepx)
	love.graphics.draw(screen)
	love.graphics.translate(GUI.config.border/2, GUI.config.border/2)
	kmeans_draw()
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
