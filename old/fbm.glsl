#include "noise.glsl"
uniform float scale;
uniform float octaves;
uniform float lacunarity;
uniform float persistence;
uniform float exponentiation;
uniform float height;
uniform float offsetx;
uniform float offsety;

vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
    vec2 oxy = vec2(offsetx,offsety);
	float G = pow(2.0, -persistence);
	float amplitude = 1.0;
	float frequency = 1.0;
	float normalization = 0.0;
	float total = 0.0;
	for (int o = 0; o < octaves; o+=1) {
		vec2 xy = (txy + oxy) / scale * frequency;
		total += (noise(xy) * 0.5 + 0.5) * amplitude;
		normalization += amplitude;
		amplitude *= G;
		frequency *= lacunarity;
	}
	total /= normalization;
	float fbm = pow(total, exponentiation) * height;
	return Texel(tex, txy) * fbm;
}
