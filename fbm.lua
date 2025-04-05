cpuORgpu,pixelcode,shader,texture,screen = false,[[
	uniform float scale;
	uniform float persistence;
	uniform float octaves;
	uniform float lacunarity;
	uniform float exponentiation;
	uniform float height;
    vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }
    float snoise(vec2 v) { // simplex noise, unlicensed, do not use commercially
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
			total += (snoise(vec2(texture_coords / scale * frequency)) * 0.5 + 0.5) * amplitude;
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
	local xs = x / config.sends.scale
	local ys = y / config.sends.scale
	local G = math.pow(2.0, -config.sends.persistence)
	local amplitude, frequency, normalization, total = 1.0, 1.0, 0.0, 0.0
	for i=1,config.sends.octaves do
		local value = love.math.noise(xs * frequency, ys * frequency) * 0.5 + 0.5
		total = total + value * amplitude
		normalization = normalization + amplitude
		amplitude = amplitude * G
		frequency = frequency * config.sends.lacunarity
	end
	total = total / normalization
	return math.pow(total, config.sends.exponentiation) * config.sends.height
end
