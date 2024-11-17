import
  pkg/sokol/app as sokol_app,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl
import pkg/rulecs
import ../../core/application
import components, systems

plugin GraphicsPlugin:
  world.addResource(
    PassAction(
      colors:
        [ColorAttachmentAction(loadAction: loadActionClear, clearValue: (0, 0, 0, 1))]
    )
  )
  world.registerRuntimeSystemsAt(PreDraw, setDefault)
  world.registerRuntimeSystemsAt(Draw, drawPoint, drawLine, drawRectangle)
  world.registerRuntimeSystemsAt(PostDraw, mainPass)

export components
