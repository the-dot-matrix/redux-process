uniform int tpx;

vec4 effect(vec4 color, Image tex, vec2 txy, vec2 sxy) {
  float a = 0.0;
  if(int(mod(sxy.x,tpx/4))==0||int(mod(sxy.y,tpx/4))==0) a=0.1;
  if(int(mod(sxy.x,tpx/2))==0||int(mod(sxy.y,tpx/2))==0) a=0.2;
  if(int(mod(sxy.x,tpx/1))==0||int(mod(sxy.y,tpx/1))==0) a=0.4;
  return vec4(1,1,1,a);
}
