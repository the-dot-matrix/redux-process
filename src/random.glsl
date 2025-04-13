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
vec2 grad(float hash) {
    // modulo below implies edge index will be int in (0..d-1)
    hash = mod(hash,p*d);
    int ei = int(hash/p);
    // random vertex of a square,+/- 1 each
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
