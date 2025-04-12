local oob,font = 55555
GUI = {}
GUI.config = {w=0,h=0,a=0.66,gui={},sends={
	scale = 0.25,
	octaves = 1,
	lacunarity = 1,
	persistence = 0,
	exponentiation = 2,
	height = 1,
	offsetx = love.math.random(-oob,oob),
	offsety = love.math.random(-oob,oob)
},tilepx=8,tilex=128,tiley=96,border=16}
function GUI.init()
    font = love.graphics.getFont()
    for k,v in pairs(GUI.config.sends) do
        table.insert(GUI.config.gui, {k, love.graphics.newText(font, k..":\t"..v)})
        shader:send(k,v)
    end
end
function GUI.visit(f, fa)
	height = love.graphics.getFont():getHeight()
	local accum = 0
	for i,v in ipairs(GUI.config.gui) do
		local text = GUI.config.gui[i]
		f(text,height)
		if fa then accum = fa(text,accum) end
		height = height + text[2]:getHeight()
	end
	return height,accum
end

GUI.mouse = {pressed=false}
function love.mousepressed(x, y, button, istouch, presses) 
	GUI.mouse.pressed = true 
	GUI.mouse.adjusting = GUI.mouse.hovering
end
function love.mousereleased(x, y, button, istouch, presses) 
	GUI.mouse.pressed = false 
	GUI.mouse.adjusting = nil
	GUI.mouse.hovering = nil
end
function love.mousemoved(x, y, dx, dy, istouch)
	local f = function(text,height)
		local w,h = text[2]:getWidth(),text[2]:getHeight()
		if x>=0 and x<=w and y>=height and y<=height+h then
			GUI.mouse.hovering = text
			if GUI.mouse.adjusting and GUI.mouse.hovering ~= GUI.mouse.adjusting then
				love.mousereleased(x,y,1,false,0)
			end
		end
	end
	GUI.visit(f)
	if GUI.mouse.adjusting then
		local key = GUI.mouse.adjusting[1]
		local text = GUI.mouse.adjusting[2]
		GUI.config.sends[key] = GUI.config.sends[key] + dx*0.01
		text:set(key..":\t"..GUI.config.sends[key])
		if not cpuORgpu and shader then 
			shader:send(key,GUI.config.sends[key])
		end
		drawn = false
	end
end
function love.keypressed(key, scancode, isrepeat)
	if key=="escape" then love.event.push("quit") end
	if key=="space" then
		GUI.config.sends["offsetx"] = love.math.random(-oob,oob)
		GUI.config.sends["offsety"] = love.math.random(-oob,oob)
		GUI.config.gui = {}
		GUI.init()
		drawn = false
	end
end

return GUI
