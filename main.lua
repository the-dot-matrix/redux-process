local mouse = {pressed=false}
local config = {
	scale = 50.0,
	persistence = 0.5,
	octaves = 3.0,
	lacunarity = 0.66,
	exponentiation = 6.66,
	height = 1.0
}
local texts = {}
local width,height = 0,0
local data, image

function computeFBM(x, y)
	local xs = x / config.scale
	local ys = y / config.scale
	local G = math.pow(2.0, -config.persistence)
	local amplitude, frequency, normalization, total = 1.0, 1.0, 0.0, 0.0
	for i=1,config.octaves do
		local value = love.math.noise(xs * frequency, ys * frequency) * 0.5 + 0.5
		total = total + value * amplitude
		normalization = normalization + amplitude
		amplitude = amplitude * G
		frequency = frequency * config.lacunarity
	end
	total = total / normalization
	return math.pow(total, config.exponentiation) * config.height
end


function love.load(args, unfilteredArgs) 
	love.graphics.setNewFont(16)
	local font = love.graphics.getFont()
	for k,v in pairs(config) do
		table.insert(texts, {k, love.graphics.newText(font, k..":\t"..v)})
	end
end

function love.update(dt)
	local w,h = love.graphics.getDimensions()
	data = love.image.newImageData(w, h)
	for y=0,h-1 do
		for x=0,w-1 do
			data:setPixel(x, y, 1, 1, 1, computeFBM(x,y))
		end
	end
	image = love.graphics.newImage(data)
end

function love.draw() 
	love.graphics.draw(image)
	love.graphics.setColor(0,0,0,1)
	love.graphics.rectangle("fill",0,0,width,height)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS:\t"..love.timer.getFPS())
	height = love.graphics.getFont():getHeight()
	width = 0
	for i,v in ipairs(texts) do
		local text = texts[i][2]
		width = math.max(width, text:getWidth())
		love.graphics.draw(text,0,height)
		height = height + text:getHeight()
	end
end

function love.mousepressed(x, y, button, istouch, presses) mouse.pressed = true end
function love.mousereleased(x, y, button, istouch, presses) mouse.pressed = false end
function love.mousemoved(x, y, dx, dy, istouch)
	if mouse.pressed then
	local height = love.graphics.getFont():getHeight()
		for i,v in ipairs(texts) do
			local key = texts[i][1]
			local text = texts[i][2]
			local w,h = text:getWidth(),text:getHeight()
			if x>=0 and x<=w and y>=height and y<=height+h then
				config[key] = config[key] + dx*0.01
				text:set(key..":\t"..config[key])
			end
			height = height + text:getHeight()
		end
	end
end
