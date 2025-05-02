const int K = 12;
uniform vec2 centroids[K];

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
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
        if (dist<=4) { alpha=1; }
        if (mindist==-1 || dist<mindist) {
            mindist = dist;
            assignment = k;
        }
    }
    float h = ((K/2)-(assignment/2)-((1.0/K)/4))/(K/2);
    float s = 1.0 / (mod(assignment,2)*2+1);
    return vec4(hsv2rgb(vec3(h,s,1)),alpha);
}
vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
    vec4 src = Texel(tex, txy);
    vec4 dst = cluster(sxy);
    return dst.a==1 ? dst : src*dst;
}
