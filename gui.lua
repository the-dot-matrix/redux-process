local w,h = love.graphics.getDimensions()

config = {w=0,h=0,a=0.88,gui={},sends={
	offsetx = love.math.random(-999,999),
	offsety = love.math.random(-999,999),
	scale = 0.25,
	persistence = 0.5,
	octaves = 1,
	lacunarity = 1,
	exponentiation = 2,
	height = 1
},scale=math.min(w,h)/math.max(w,h)*8}
function visit(f, fa)
	height = love.graphics.getFont():getHeight()
	local accum = 0
	for i,v in ipairs(config.gui) do
		local text = config.gui[i]
		f(text,height)
		if fa then accum = fa(text,accum) end
		height = height + text[2]:getHeight()
	end
	return height,accum
end

mouse = {pressed=false}
function love.mousepressed(x, y, button, istouch, presses) 
	mouse.pressed = true 
	mouse.adjusting = mouse.hovering
end
function love.mousereleased(x, y, button, istouch, presses) 
	mouse.pressed = false 
	mouse.adjusting = nil
	mouse.hovering = nil
end
function love.mousemoved(x, y, dx, dy, istouch)
	local f = function(text,height)
		local w,h = text[2]:getWidth(),text[2]:getHeight()
		if x>=0 and x<=w and y>=height and y<=height+h then
			mouse.hovering = text
			if mouse.adjusting and mouse.hovering ~= mouse.adjusting then
				love.mousereleased(x,y,1,false,0)
			end
		end
	end
	visit(f)
	if mouse.adjusting then
		local key = mouse.adjusting[1]
		local text = mouse.adjusting[2]
		config.sends[key] = config.sends[key] + dx*0.01
		text:set(key..":\t"..config.sends[key])
		if not cpuORgpu and shader then shader:send(key,config.sends[key]) end
	end
end
function love.keypressed(key, scancode, isrepeat)
	if key=="escape" then love.event.push("quit") end
end
