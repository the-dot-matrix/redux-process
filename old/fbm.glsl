uniform float scale;
uniform float octaves;
uniform float lacunarity;
uniform float persistence;
uniform float exponentiation;
uniform float height;
uniform float offsetx;
uniform float offsety;
const float q = 17.0000000; // 1st arbitrary prime
const float r = 53.0000000; // 2nd arbitrary prime
const float s = 131.000000; // 3rd arbitrary prime
const float i = 0.75000000; // i in I unit interval
const float m = pow(q,2.0); // modulus
const float d = 2.00000000; // #dimensions
const float p = pow(2.0,d); // 2^#dimensions
const vec2 dp = vec2(d, p); // vector of dimension and power
const float g = sqrt(d* i); // gradient expansion
const float e = s/q/100.00; // point shortener
const float c = s/r+ r/q*i; // hash constant

vec3 permute(vec3 t) { return t * (t * r-i + s); }
vec2 grad2(float hash) {
    // modulo below implies edge index will be int in (0..d-1)
	hash = mod(hash,p*d);
    int ei = int(hash/p);
    // random vertex of a square, +/- 1 each
    // pick one of the p points on the face
    vec2 square = mod(floor(hash/dp),d)*d - 1.0;
    float point = mod(floor(hash/p), d);
    // zero random edge of the d edges connected to the vertex
    vec2 sqrquad = square;
    sqrquad[ei] = 0.0;
    // define the face between the square vertex and point
    float cross = square.x * sqrquad.y + sqrquad.x * square.y;
    vec2 face = (1.0-point)*square + point*(sqrquad+cross);
    // expand point new edges are same length as existing ones
    vec2 grad = sqrquad * g + face;
    // make all gradients the same length, shorten the point
    grad *= (1.0 - e * point) * c;
    return grad;
}
vec3 my_own_impl_of_2d_opensimplex2s_derive(vec2 xy) {
    // bcc lattice split up into 2 square lattices
    vec2 b0 = floor(xy);
    vec3 i3 = vec3(xy-b0,3.0);
    // pick between pairs of oppposite corners in the square
    float pp = floor(dot(i3,vec3(1-i,1-i,1-i)));
    float np = floor(dot(i3,vec3(i-1,1-i,1-i)));
    float pn = floor(dot(i3,vec3(1-i,i-1,1-i)));
    vec2 v1 = b0 + vec2(0,0) + vec2( 1,1) * pp;
    vec2 v2 = b0 + vec2(1,0) + vec2(-1,1) * np;
    vec2 v3 = b0 + vec2(0,1) + vec2(1,-1) * pn;
    // kernel function
    vec2 d1 = xy - v1;
    vec2 d2 = xy - v2;
    vec2 d3 = xy - v3;
    vec3 a0 = vec3(dot(d1,d1), dot(d2,d2), dot(d3,d3));
    vec3 a1 = max(i-a0,0.0);
    vec3 a2 = a1 * a1;
    vec3 a4 = a2 * a2;
    // gradient hashes of the d+1 vertices in the half-lattice
    vec3 hashes = vec3(0.0);
    hashes = permute(mod(hashes + vec3(v1.x, v2.x, v3.x), m));
    hashes = permute(mod(hashes + vec3(v1.y, v2.y, v3.y), m));
    // gradient extrapolations
    vec2 g1 = grad2(hashes.x);
    vec2 g2 = grad2(hashes.y);
    vec2 g3 = grad2(hashes.z);
    // derivatives of the noise
    vec3 extrapolate = vec3(dot(d1,g1),dot(d2,g2),dot(d3,g3));
    vec2 kernel = -p * mat3x2(d1,d2,d3) * (a2*a1*extrapolate);
    vec2 gradient = mat3x2(g1,g2,g3) * a4;
    vec2 derive = kernel + gradient;
    // return it all as a vec(d+1)
    return vec3(derive, dot(a4,extrapolate));
}
vec3 my_own_impl_of_2d_opensimplex2s(vec2 xy) {
    vec3 a = my_own_impl_of_2d_opensimplex2s_derive(xy);
    vec3 b = my_own_impl_of_2d_opensimplex2s_derive(xy+m/2);
    return a + b;
}
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
    vec2 oxy = vec2(offsetx,offsety);
	float G = pow(2.0, -persistence);
	float amplitude = 1.0;
	float frequency = 1.0;
	float normalization = 0.0;
	float total = 0.0;
	for (int o = 0; o < octaves; o+=1) {
		vec2 xy = (txy + oxy) / scale * frequency;
		float noise = my_own_impl_of_2d_opensimplex2s(xy)[2];
		total += (noise * 0.5 + 0.5) * amplitude;
		normalization += amplitude;
		amplitude *= G;
		frequency *= lacunarity;
	}
	total /= normalization;
	float fbm = pow(total, exponentiation) * height;
	return Texel(tex, txy) * fbm;
}
