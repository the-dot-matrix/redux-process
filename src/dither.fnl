(import-macros {: extends : new} :λ.class)
(extends Dither (require :src.screen))
(new Dither [! w h :src.dither.glsl])
Dither
