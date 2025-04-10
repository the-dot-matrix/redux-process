require("fbm")
require("gui")
require("kmeans")
w,h,font = love.graphics.getDimensions()
local image,data
drawn = false

function love.load(args, unfilteredArgs) 
	w,h=love.window.getDesktopDimensions()
	love.window.setMode(w,h)
	love.graphics.setDefaultFilter("nearest","nearest")
    love.graphics.setNewFont(32)
    font = love.graphics.getFont()
    shader = love.graphics.newShader("fbm.glsl")
    dither = love.graphics.newShader("dither.glsl")
    for k,v in pairs(config.sends) do
        table.insert(config.gui, {k, love.graphics.newText(font, k..":\t"..v)})
        shader:send(k,v)
    end
    texture = love.graphics.newCanvas(config.tilex,config.tiley)
    todither = love.graphics.newCanvas(config.tilex,config.tiley)
    dithered = love.graphics.newCanvas(config.tilex,config.tiley)
    screen = love.graphics.newCanvas(config.tilex+config.border,config.tiley+config.border)
end

function love.update(dt)
    if cpuORgpu and not drawn then 
		data = love.image.newImageData(config.tilex,config.tiley)
		for y=0,config.tiley-1 do
			for x=0,config.tilex-1 do
				data:setPixel(x, y, 1, 1, 1, computeFBM(x,y))
			end
		end
		image = love.graphics.newImage(data)
	end
	if drawn and not clustering then
		image2points(dithered:newImageData(nil,nil,0,0,todither:getWidth(),todither:getHeight()))
		clustering = true
	else
		clustering = drawn
	end
	if clustering and not converged then
		kmeans_iter()
	else
		converged = not clustering
	end
end

function love.draw()
	if not drawn then
		love.graphics.setCanvas(texture)
		love.graphics.setColor(1,1,1,1)
		love.graphics.rectangle("fill",0,0,config.tilex,config.tiley)
		
		love.graphics.setCanvas(todither)
		love.graphics.clear(0,0,0,1)
		if cpuORgpu then 
			love.graphics.draw(image)
		else
			love.graphics.setShader(shader)
			love.graphics.draw(texture)
		end

		love.graphics.setCanvas(dithered)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader(dither)
		love.graphics.draw(todither)
		
		love.graphics.setCanvas(screen)
		love.graphics.clear(0,0,0,1)
		love.graphics.setShader()
		love.graphics.draw(dithered,config.border/2,config.border/2)

		love.graphics.setCanvas()
		love.graphics.setColor(1,1,1,1)
		drawn = true
	end
	love.graphics.clear(0.25,0.25,0.25,1)
	love.graphics.push()
	love.graphics.translate((w-screen:getWidth()*config.tilepx)/2,(h-screen:getHeight()*config.tilepx)/2)
	love.graphics.scale(config.tilepx,config.tilepx)
	love.graphics.draw(screen)
	love.graphics.translate(config.border/2, config.border/2)
	kmeans_draw()
	love.graphics.pop()
	love.graphics.setColor(0,0,0,config.a)
	love.graphics.rectangle("fill",0,0,config.w,config.h)
	local fps = love.timer.getFPS()
	if fps<99 then love.graphics.setColor(0.11,0.99,0.11,config.a) end
	if fps<60 then love.graphics.setColor(0.99,0.99,0.11,config.a) end
	if fps<30 then love.graphics.setColor(0.99,0.11,0.11,config.a) end
	love.graphics.print("FPS:"..fps)
	local f = function(text,height) 
		love.graphics.setColor(0.44,0.44,0.44,config.a)
		if mouse.hovering and mouse.hovering[1]==text[1] then love.graphics.setColor(0.66,0.66,0.66,config.a) end
		if mouse.adjusting and mouse.adjusting[1]==text[1] then love.graphics.setColor(0.88,0.88,0.88,config.a) end
		love.graphics.draw(text[2],0,height) 
	end
	local fa = function(text,accum) return math.max(accum,text[2]:getWidth()) end
	config.h,config.w = visit(f, fa)
	love.graphics.setColor(1,1,1,1)
end
