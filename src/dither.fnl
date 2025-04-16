(import-macros {: extends : new} :mac.class)
(extends Dither (require :src.screen))
(new Dither [! w h :gpu.dither.glsl])
Dither
