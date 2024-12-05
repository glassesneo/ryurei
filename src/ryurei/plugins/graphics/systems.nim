import
  pkg/sokol/app as sokol_app,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl
import pkg/rulecs
import pkg/vmath
import ../../core/types
import components

func setDefault*() {.system.} =
  sokol_gl.defaults()
  sokol_gl.matrixModeProjection()
  sokol_gl.ortho(0, sokol_app.width().float, sokol_app.height().float, 0, -1, 1)

func drawPoint*(pointQuery: [All[Point, Transform2D, RyureiColor]]) {.system.} =
  sokol_gl.beginPoints()
  for entity, tf, color in pointQuery of (Transform2D, RyureiColor):
    sokol_gl.v2fC4b(tf.position.x, tf.position.y, color.r, color.g, color.b, color.a)
  sokol_gl.end()

func drawLine*(lineQuery: [All[Line, Transform2D, RyureiColor]]) {.system.} =
  sokol_gl.beginLines()
  for entity, line, tf, color in lineQuery of (Line, Transform2D, RyureiColor):
    sokol_gl.c4b(color.r, color.g, color.b, color.a)
    sokol_gl.v2f(tf.position.x, tf.position.y)
    sokol_gl.v2f(tf.position.x + line.size.x, tf.position.y + line.size.y)
  sokol_gl.end()

func drawRectangle*(rectQuery: [All[Rectangle, Transform2D, RyureiColor]]) {.system.} =
  sokol_gl.beginQuads()
  for entity, rect, tf, color in rectQuery of (Rectangle, Transform2D, RyureiColor):
    sokol_gl.c4b(color.r, color.g, color.b, color.a)
    sokol_gl.v2f(tf.position.x, tf.position.y)
    sokol_gl.v2f(tf.position.x + rect.size.x, tf.position.y)
    sokol_gl.v2f(tf.position.x + rect.size.x, tf.position.y + rect.size.y)
    sokol_gl.v2f(tf.position.x, tf.position.y + rect.size.y)
  sokol_gl.end()

func mainPass*(passAction: Resource[PassAction]) {.system.} =
  sokol_gfx.beginPass(Pass(action: passAction, swapchain: sokol_glue.swapchain()))
  sokol_gl.draw()
  sokol_gfx.endPass()
  sokol_gfx.commit()
