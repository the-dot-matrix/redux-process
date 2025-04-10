cpuORgpu,shader = false
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
