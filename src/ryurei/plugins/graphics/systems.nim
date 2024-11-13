import
  pkg/sokol/app as sokol_app,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl
import pkg/rulecs
import pkg/vmath
import ../../core/types
import components

func drawPoint*(pointQuery: [All[Point, Transform2D, RyureiColor]]) {.system.} =
  sokol_gl.beginPoints()
  for id, tf, color in pointQuery of (Transform2D, RyureiColor):
    sokol_gl.c4b(color.r, color.g, color.b, color.a)
    sokol_gl.v2f(tf.position.x, tf.position.y)
  sokol_gl.end()
