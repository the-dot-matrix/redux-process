(import-macros {: extends : new} :λ.class)
(extends Grid (require :src.screen))
(new Grid [! w h :src.shader.grid.glsl sends])

Grid
