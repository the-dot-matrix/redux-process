(import-macros {: extends : new} :syntax.class)
(extends Dither (require :source.screen))
(new Dither [! w h :source.shader.dither.glsl])
Dither
