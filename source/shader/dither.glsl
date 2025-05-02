const int m = 8;
const int M = m*m;
const int thresholdmap[M] =
  int[](0,  32, 8,  40, 2,  34, 10, 42,
        48, 16, 56, 24, 50, 18, 58, 26,
        12, 44, 4,  36, 14, 46, 6,  38,
        60, 28, 52, 20, 62, 30, 54, 22,
        3,  35, 11, 43, 1,  33, 9,  41,
        51, 19, 59, 27, 49, 17, 57, 25,
        15, 47, 7,  39, 13, 45, 5,  37,
        63, 31, 55, 23, 61, 29, 53, 21);

vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  int x = int(mod(sxy.x, m));
  int y = int(mod(sxy.y, m));
  float d = thresholdmap[(x + y * m)] / float(M);
  vec4 average = vec4(1.0/3.0, 1.0/3.0, 1.0/3.0, 0.0);
  float unitinterval = dot(Texel(tex, txy), average);
  int nearcolor = (unitinterval < 0.5) ? 0 : 1;
  int farcolor = 1 - nearcolor;
  float distance = abs(nearcolor - unitinterval);
  return (distance <= d) ? vec4(nearcolor) : vec4(farcolor);
}
