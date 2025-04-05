require("fbm")
require("gui")
local w,h = love.graphics.getDimensions()
local image,data

function love.load(args, unfilteredArgs) 
	w,h=love.window.getDesktopDimensions()
	love.window.setMode(w,h)
	love.graphics.setDefaultFilter("nearest","nearest")
    love.graphics.setNewFont(32)
    local font = love.graphics.getFont()
    shader = love.graphics.newShader(fbmglsl)
    dither = love.graphics.newShader("dither.glsl")
    for k,v in pairs(config.sends) do
        table.insert(config.gui, {k, love.graphics.newText(font, k..":\t"..v)})
        shader:send(k,v)
    end
    fbm = love.graphics.newCanvas(w/config.scale, h/config.scale)
    dithered = love.graphics.newCanvas(w/config.scale, h/config.scale)
    screen = love.graphics.newCanvas(w/config.scale, h/config.scale)
end

function love.update(dt)
    if cpuORgpu then 
		data = love.image.newImageData(w/config.scale,h/config.scale)
		for y=0,h/config.scale-1 do
			for x=0,w/config.scale-1 do
				data:setPixel(x, y, 1, 1, 1, computeFBM(x,y))
			end
		end
		image = love.graphics.newImage(data)
	end
end

function love.draw()
	if cpuORgpu then love.graphics.draw(image,0,0,0,config.scale,config.scale)
	else
		love.graphics.setCanvas(fbm)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,w/config.scale,h/config.scale)
		
		love.graphics.setCanvas(dithered)
		love.graphics.clear()
		love.graphics.setShader(shader)
		love.graphics.draw(fbm)
		
		love.graphics.setCanvas(screen)
		love.graphics.clear()
		love.graphics.setShader(dither)
		love.graphics.draw(dithered)
		
		love.graphics.setCanvas()
		love.graphics.clear()
		love.graphics.setShader()
		love.graphics.draw(screen,0,0,0,config.scale,config.scale)
	end
	love.graphics.setColor(0,0,0,config.a)
	love.graphics.rectangle("fill",0,0,config.w,config.h)
	local fps = love.timer.getFPS()
	if fps<99 then love.graphics.setColor(0.11,0.99,0.11,config.a) end
	if fps<60 then love.graphics.setColor(0.99,0.99,0.11,config.a) end
	if fps<30 then love.graphics.setColor(0.99,0.11,0.11,config.a) end
	love.graphics.print("FPS:\t"..fps)
	local f = function(text,height) 
		love.graphics.setColor(0.44,0.11,0.44,config.a)
		if mouse.hovering and mouse.hovering[1]==text[1] then love.graphics.setColor(0.88,0.11,0.88,config.a) end
		if mouse.adjusting and mouse.adjusting[1]==text[1] then love.graphics.setColor(0.88,0.88,0.88,config.a) end
		love.graphics.draw(text[2],0,height) 
	end
	local fa = function(text,accum) return math.max(accum,text[2]:getWidth()) end
	config.h,config.w = visit(f, fa)
	love.graphics.setColor(1,1,1,1)
end
