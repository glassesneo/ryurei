import
  pkg/sokol/app as sokol_app,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl
import pkg/rulecs
import ../../core/application
import components, systems

plugin GraphicsPlugin:
  world.registerRuntimeSystem(drawPoint)
  world.registerRuntimeSystem(drawLine)
  world.registerRuntimeSystem(drawRectangle)

export components
