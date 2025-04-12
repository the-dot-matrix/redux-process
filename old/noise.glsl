#include "random.glsl"
// my reimplementation of opensimplex2s(CC0 universal) in 2d
vec3 dnoise(vec2 xy) {
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
    // gradient hashes of the d+1 vertices in the half-lattice
    vec2 d1 = xy-v1; vec2 d2 = xy-v2; vec2 d3 = xy-v3;
    vec3 a0 = vec3(dot(d1,d1), dot(d2,d2), dot(d3,d3));
    vec3 a1 = max(i-a0,0.0); vec3 a2 = a1*a1; vec3 a4 = a2*a2;
    vec3 hashes = vec3(0.0);
    hashes = permute(mod(hashes + vec3(v1.x, v2.x, v3.x), m));
    hashes = permute(mod(hashes + vec3(v1.y, v2.y, v3.y), m));
    // gradients, derivatives, extrapolations
    vec2 g1 = grad(hashes.x);
    vec2 g2 = grad(hashes.y);
    vec2 g3 = grad(hashes.z);
    vec3 extrapolate = vec3(dot(d1,g1),dot(d2,g2),dot(d3,g3));
    vec2 kernel = -p * mat3x2(d1,d2,d3) * (a2*a1*extrapolate);
    vec2 gradient = mat3x2(g1,g2,g3) * a4;
    vec2 derive = kernel + gradient;
    return vec3(derive, dot(a4,extrapolate));
}
float noise(vec2 xy) { return (dnoise(xy)+dnoise(xy+m/2))[2]; }
