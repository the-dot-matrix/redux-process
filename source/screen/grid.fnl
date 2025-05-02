(import-macros {: extends : new} :syntax.class)
(extends Grid (require :source.screen))
(new Grid [! w h :source.shader.grid.glsl sends])

Grid
