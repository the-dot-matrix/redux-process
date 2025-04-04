local mouse = {pressed=false}
local config = {
	scale = 66.6,
	persistence = 5.55,
	octaves = 3,
	lacunarity = 2.22,
	exponentiation = 1.33,
	height = 1.33
}
local texts = {}
local width,height = 0,0
local image,data,shader
local pixelcode = [[
	uniform float scale;
	uniform float persistence;
	uniform float octaves;
	uniform float lacunarity;
	uniform float exponentiation;
	uniform float height;
    vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }
    float snoise(vec2 v) { // simplex noise
        const vec4 C = vec4(0.211324865405187, 0.366025403784439,-0.577350269189626, 0.024390243902439);
        vec2 i  = floor(v + dot(v, C.yy) );
        vec2 x0 = v -   i + dot(i, C.xx);
        vec2 i1;
        i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
        vec4 x12 = x0.xyxy + C.xxzz;
        x12.xy -= i1;
        i = mod(i, 289.0);
        vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));
        vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
        dot(x12.zw,x12.zw)), 0.0);
        m = m*m ;
        m = m*m ;
        vec3 x = 2.0 * fract(p * C.www) - 1.0;
        vec3 h = abs(x) - 0.5;
        vec3 ox = floor(x + 0.5);
        vec3 a0 = x - ox;
        m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
        vec3 g;
        g.x  = a0.x  * x0.x  + h.x  * x0.y;
        g.yz = a0.yz * x12.xz + h.yz * x12.yw;
        return 130.0 * dot(m, g);
    }
	vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
		float G = pow(2.0, -persistence);
		float amplitude = 1.0;
		float frequency = 1.0;
		float normalization = 0.0;
		float total = 0.0;
		for (int o = 0; o < octaves; o+=1) {
			total += (snoise(vec2(screen_coords / scale * frequency)) * 0.5 + 0.5) * amplitude;
			normalization += amplitude;
			amplitude *= G;
			frequency *= lacunarity;
		}
		total /= normalization;
		float fbm = pow(total, exponentiation) * height;
    	vec4 texturecolor = Texel(tex, texture_coords);
    	return texturecolor * color * fbm;
	}
]]

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
    shader = love.graphics.newShader(pixelcode)
    for k,v in pairs(config) do
        table.insert(texts, {k, love.graphics.newText(font, k..":\t"..v)})
        shader:send(k,v)
    end
end

function love.update(dt)
    -- slow, but works the same as the shader
	-- local w,h = love.graphics.getDimensions()
	-- data = love.image.newImageData(w, h)
	-- for y=0,h-1 do
	-- 	for x=0,w-1 do
	-- 		data:setPixel(x, y, 1, 1, 1, computeFBM(x,y))
	-- 	end
	-- end
	-- image = love.graphics.newImage(data)
end

function love.draw() 
	love.graphics.setShader(shader)
	local w,h = love.graphics.getDimensions()
	love.graphics.rectangle("fill",0,0,w,h)
	love.graphics.setShader()
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
				shader:send(key,config[key])
			end
			height = height + text:getHeight()
		end
	end
end
