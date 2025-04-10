uniform float offsetx;
uniform float offsety;
uniform float scale;
uniform float persistence;
uniform float octaves;
uniform float lacunarity;
uniform float exponentiation;
uniform float height;

vec3 permute3(vec3 t) { return t * (t * 34.0 + 133.0); }
// Gradient set is a normalized expanded rhombic dodecahedron
vec2 grad2(float hash) {
	hash = mod(hash, 32.0); // mod 2*16, two edges in 2d, not three
    // Random vertex of a SQUARE, +/- 1 each
    vec2 square = mod(floor(hash / vec2(2.0, 8.0)), 2.0) * 2.0 - 1.0;
    // Random edge of the TWO edges connected to that vertex
    // And corresponds to the face of its dual, the rhombic dodecahedron
    vec2 sqroct = square;
    sqroct[int(hash / 16.0)] = 0.0;
    // In a funky way, pick one of the four points on the rhombic face
    float type = mod(floor(hash / 8.0), 2.0);
    float cross = square.x * sqroct.y + sqroct.x * square.y;
    vec2 rhomb = (1.0 - type) * square + type * (sqroct + cross);
    // Expand it so that the new edges are the same length
    // as the existing ones
    vec2 grad = sqroct * 1.22474487139 + rhomb;
    // To make all gradients the same length, we only need to shorten the
    // second type of vector. We also put in the whole noise scale constant.
    // The compiler should reduce it into the existing floats. I think.
    grad *= (1.0 - 0.042942436724648037 * type) * 3.5946317686139184;
    return grad*16;
}
// BCC lattice split up into 2 SQUARE lattices
vec3 my_own_implementation_of_2d_opensimplex2s_derivatives(vec2 xy) {
    vec2 b = floor(xy);
    vec3 i3 = vec3(xy - b, 2.15);
    // Pick between each pair of oppposite corners in the SQUARE.
    vec2 v1 = b + floor(dot(i3, vec3(.25,.25,.35)));
    vec2 v2 = b + vec2(1, 0) + vec2(-1, 1) * floor(dot(i3, vec3(-.25, .25, .35)));
    vec2 v3 = b + vec2(0, 1) + vec2(1, -1) * floor(dot(i3, vec3( .25,-.25, .35)));
    // Kernel function
    vec2 d1 = xy - v1; 
    vec2 d2 = xy - v2;
    vec2 d3 = xy - v3;
    vec3 a = max(0.5 - vec3(dot(d1, d1), dot(d2, d2), dot(d3, d3)), 0.0);
    vec3 aa = a * a; 
    vec3 aaaa = aa * aa;
    // Gradient hashes for the four vertices in this half-lattice.
    vec3 hashes = permute3(mod(vec3(v1.x, v2.x, v3.x), 289.0));
    hashes = permute3(mod(hashes + vec3(v1.y, v2.y, v3.y), 289.0));
    vec2 g1 = grad2(hashes.x); 
    vec2 g2 = grad2(hashes.y);
    vec2 g3 = grad2(hashes.z);
    vec3 extrapolations = vec3(dot(d1, g1), dot(d2, g2), dot(d3, g3));
    // Derivatives of the noise
    vec2 derivative = -8.0 * mat3x2(d1, d2, d3) * (aa * a * extrapolations) + mat3x2(g1, g2, g3) * aaaa;
    // Return it all as a vec3
    return vec3(derivative, dot(aaaa, extrapolations));
}
vec3 my_own_implementation_of_2d_opensimplex2s(vec2 xy) {
    //xy = dot(xy, vec2(mystery)) - xy; no skew
    vec3 a = my_own_implementation_of_2d_opensimplex2s_derivatives(xy);
    vec3 b = my_own_implementation_of_2d_opensimplex2s_derivatives(xy + 144.5);
    return a + b;
}
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
	float G = pow(2.0, -persistence);
	float amplitude = 1.0;
	float frequency = 1.0;
	float normalization = 0.0;
	float total = 0.0;
	for (int o = 0; o < octaves; o+=1) {
		vec2 coords = (texture_coords + vec2(offsetx,offsety)) / scale * frequency;
		float mynoise = my_own_implementation_of_2d_opensimplex2s(coords)[2];
		total += (mynoise * 0.5 + 0.5) * amplitude;
		normalization += amplitude;
		amplitude *= G;
		frequency *= lacunarity;
	}
	total /= normalization;
	float fbm = pow(total, exponentiation) * height;
	vec4 texturecolor = Texel(tex, texture_coords);
	return texturecolor * fbm;
}
