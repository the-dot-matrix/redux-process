(import-macros {: extends : new} :λ.class)
(import-macros {: update} :λ.aGUI)
(extends Grid (require :src.screen))
(new Grid [! w h :src.shader.grid.glsl sends])

Grid
