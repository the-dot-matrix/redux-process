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
    fbm = love.graphics.newCanvas(config.tilex,config.tiley)
    dithered = love.graphics.newCanvas(config.tilex+config.border,config.tiley+config.border)
    screen = love.graphics.newCanvas(config.tilex+config.border,config.tiley+config.border)
end

function love.update(dt)
    if cpuORgpu then 
		data = love.image.newImageData(config.tilex,config.tiley)
		for y=0,h/config.tilepx-1 do
			for x=0,w/config.tilepx-1 do
				data:setPixel(x, y, 1, 1, 1, computeFBM(x,y))
			end
		end
		image = love.graphics.newImage(data)
	end
end

function love.draw()
	if cpuORgpu then love.graphics.draw(image,0,0,0,config.tilepx,config.tilepx)
	else
		love.graphics.setCanvas(fbm)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,config.tilex,config.tiley)
		
		love.graphics.setCanvas(dithered)
		love.graphics.clear()
		love.graphics.setShader(shader)
		love.graphics.draw(fbm,config.border/2,config.border/2)
		
		love.graphics.setCanvas(screen)
		love.graphics.clear()
		love.graphics.setShader(dither)
		love.graphics.draw(dithered)
		
		love.graphics.setCanvas()
		love.graphics.setShader()
		love.graphics.clear(0.25,0.25,0.25,1)
		love.graphics.draw(screen,(w-screen:getWidth()*config.tilepx)/2,(h-screen:getHeight()*config.tilepx)/2,0,config.tilepx,config.tilepx)
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
