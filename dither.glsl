const int bayer[64] = 
  int[](1/*0*/,  32, 8,  40, 2,  34, 10, 42,
        48, 16, 56, 24, 50, 18, 58, 26,
        12, 44, 4,  36, 14, 46, 6,  38,
        60, 28, 52, 20, 62, 30, 54, 22,
        3,  35, 11, 43, 1,  33, 9,  41,
        51, 19, 59, 27, 49, 17, 57, 25,
        15, 47, 7,  39, 13, 45, 5,  37,
        63, 31, 55, 23, 61, 29, 53, 21);

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
  int x = int(mod(screen_coords.x, 8));
  int y = int(mod(screen_coords.y, 8));
  float d = bayer[(x + y * 8)] / 64.0;
  vec4 texturecolor = Texel(tex, texture_coords);
  float dither = (texturecolor[0]+texturecolor[1]+texturecolor[2])/3;
  float closestColor = (dither < 0.5) ? 0 : 1;
  float secondClosestColor = 1 - closestColor;
  float distance = abs(closestColor - dither);
  return (distance < d) ? vec4(closestColor,closestColor,closestColor,closestColor) : vec4(secondClosestColor,secondClosestColor,secondClosestColor,secondClosestColor);
}
