const int K = 12;
const vec3 colors[K] = vec3[](
    vec3(1.00,  0.00,  0.00),
    vec3(1.00,  1.00,  0.00),
    vec3(0.00,  1.00,  0.00),
    vec3(0.00,  1.00,  1.00),
    vec3(0.00,  0.00,  1.00),
    vec3(1.00,  0.00,  1.00),
    vec3(1.00,  0.50,  0.00),
    vec3(1.00,  1.00,  0.50),
    vec3(0.00,  1.00,  0.50),
    vec3(0.50,  1.00,  1.00),
    vec3(0.50,  0.00,  1.00),
    vec3(1.00,  0.50,  1.00));
uniform vec2 centroids[K];

float distance(vec2 p1, vec2 p2) {
    float a = abs(p1[0]-p2[0]);
    float b = abs(p1[1]-p2[1]);
    return sqrt(pow(a,2)+pow(b,2));
}
vec4 cluster(vec2 p) {
    float alpha = 0.5;
    float mindist = -1;
    int assignment = -1;
    for (int k = 0; k < K; k += 1) {
        float dist = distance(p, centroids[k]);
        if (dist<=1) { alpha=1; }
        if (mindist==-1 || dist<mindist) {
            mindist = dist;
            assignment = k;
        }
    }
    return vec4(colors[assignment],alpha);
}
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
    vec4 src = Texel(tex, txy);
    vec4 dst = cluster(sxy);
    return dst.a==1 ? dst : src*dst;
}
