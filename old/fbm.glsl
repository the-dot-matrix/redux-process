uniform float offsetx;
uniform float offsety;
uniform float scale;
uniform float persistence;
uniform float octaves;
uniform float lacunarity;
uniform float exponentiation;
uniform float height;
uniform float mystery;
const float z = 3.00000000; // z-axis
const float i = 0.75000000; // i in I unit interval
const float m = 289.000000; // modulus
const float d = 2.00000000; // dimensions
const float p = pow(2.0,d); // 2^#dimensions
const vec2 dp = vec2(d, p); // vector of dimension and power

vec3 permute3(vec3 t) { return t * (t * 34.0 + 133.0); }
// Gradient set is a normalized expanded rhombic dodecahedron
// TODO reorder based on os2s.glsl and name rest of the magic numbers
vec2 grad2(float hash) {
    // modulo below guarantees division after will return an int in (0..d-1)
	hash = mod(hash, 4*d);
    int e = int(hash/2*d);
    // Random vertex of a SQUARE, +/- 1 each
    // And corresponds to the face of its dual, the rhombic dodecahedron
    // In a funky way, pick one of the four points on the rhombic face
    vec2 square = mod(floor(hash/dp),d) * d - 1.0;
    float power = mod(floor(hash/p),d);
    // zero out a random edge of the d edges connected to that vertex
    vec2 sqroct = square;
    sqroct[e] = 0.0; 
    // Expand it so that the new edges are 
    // the same length as the existing ones
    float cross = square.x * sqroct.y + sqroct.x * square.y;
    vec2 rhomb = (1.0 - power) * square + power * (sqroct + cross);
    vec2 grad = sqroct * 1.22474487139 + rhomb;
    // To make all gradients the same length, we only need to shorten
    // the second type of vector (power p not dimension d)
    // We also put in the whole noise scale constant.
    // The compiler should reduce it into the existing floats. I think.
    grad *= (1.0 - 0.042942436724648037 * power) * 3.5946317686139184;
    return grad;
}
vec3 my_own_rewrite_of_2d_opensimplex2s_derive(vec2 xy) {
    // BCC lattice split up into 2 SQUARE lattices
    vec2 b0 = floor(xy);
    vec3 i3 = vec3(xy-b0,z);
    // Pick between each pair of oppposite corners in the SQUARE
    vec2 v1 = b0 + vec2(0,0) + vec2( 1,1) * floor(dot(i3,vec3(1-i,1-i,1-i)));
    vec2 v2 = b0 + vec2(1,0) + vec2(-1,1) * floor(dot(i3,vec3(i-1,1-i,1-i)));
    vec2 v3 = b0 + vec2(0,1) + vec2(1,-1) * floor(dot(i3,vec3(1-i,i-1,1-i)));
    // Kernel function
    vec2 d1 = xy - v1;
    vec2 d2 = xy - v2;
    vec2 d3 = xy - v3;
    vec3 a0 = vec3(dot(d1,d1), dot(d2,d2), dot(d3,d3));
    vec3 a1 = max(i-a0,0.0);
    vec3 a2 = a1 * a1;
    vec3 a4 = a2 * a2;
    // Gradient hashes for the THREE vertices in this half-lattice
    vec3 hashes = vec3(0.0);
    hashes = permute3(mod(hashes + vec3(v1.x, v2.x, v3.x), m));
    hashes = permute3(mod(hashes + vec3(v1.y, v2.y, v3.y), m));
    vec2 g1 = grad2(hashes.x);
    vec2 g2 = grad2(hashes.y);
    vec2 g3 = grad2(hashes.z);
    // Derivatives of the noise
    vec3 extrapolations = vec3(dot(d1,g1), dot(d2,g2), dot(d3,g3));
    vec2 derivative = -p * mat3x2(d1,d2,d3) * (a2*a1*extrapolations) + mat3x2(g1,g2,g3) * a4;
    // Return it all as a vec3
    return vec3(derivative, dot(a4,extrapolations));
}
vec3 my_own_rewrite_of_2d_opensimplex2s(vec2 xy) {
    vec3 a = my_own_rewrite_of_2d_opensimplex2s_derive(xy);
    vec3 b = my_own_rewrite_of_2d_opensimplex2s_derive(xy+m/2);
    return a + b;
}
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
	float G = pow(2.0, -persistence);
	float amplitude = 1.0;
	float frequency = 1.0;
	float normalization = 0.0;
	float total = 0.0;
	for (int o = 0; o < octaves; o+=1) {
        vec2 oxy = vec2(offsetx,offsety);
		vec2 xy = (txy + oxy) / scale * frequency;
		float noise = my_own_rewrite_of_2d_opensimplex2s(xy)[2];
		total += (noise * 0.5 + 0.5) * amplitude;
		normalization += amplitude;
		amplitude *= G;
		frequency *= lacunarity;
	}
	total /= normalization;
	float fbm = pow(total, exponentiation) * height;
	vec4 texturecolor = Texel(tex, txy);
    vec2 xy = txy / scale;
    float n = my_own_rewrite_of_2d_opensimplex2s(xy)[2];
    float m = mystery;
	return texturecolor * n;
}
