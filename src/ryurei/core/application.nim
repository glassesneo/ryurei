{.experimental: "strictFuncs".}
{.experimental: "strictDefs".}
{.experimental: "views".}

import pkg/rulecs
import pkg/seiryu
import
  pkg/sokol/app as sokol_app,
  pkg/sokol/log as sokol_log,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl

type
  Plugin* =
    concept type P
        P.build(var World)
  Application* = object
    world*: World

func init*(T: type Application): T {.construct.} =
  result.world = World.init()
  result.world.setupSystems()

proc loadPlugin*[T: Plugin](app: var Application, P: type T) =
  P.build(app.world)

template run*(app: var Application, body: untyped) =
  block:
    template world(): World {.used, inject.} =
      app.world

    proc appInit() {.cdecl.} =
      sokol_gfx.setup(
        sokol_gfx.Desc(
          environment: sokol_glue.environment(),
          logger: sokol_gfx.Logger(fn: sokol_log.fn),
        )
      )
      sokol_gl.setup(sokol_gl.Desc())
      body

    proc appFrame() {.cdecl.} =
      sokol_gl.defaults()
      sokol_gl.matrixModeProjection()
      sokol_gl.ortho(0, sokol_app.width().float, sokol_app.height().float, 0, -1, 1)
      app.world.performRuntimeSystems()
      sokol_gfx.beginPass(Pass(action: PassAction(), swapchain: sokol_glue.swapchain()))
      sokol_gl.draw()
      sokol_gfx.draw(0, 3, 1)
      sokol_gfx.endPass()
      sokol_gfx.commit()

    proc appCleanup() {.cdecl.} =
      sokol_gfx.shutdown()

    sokol_app.run(
      sokol_app.Desc(
        initCb: appInit,
        frameCb: appFrame,
        cleanupCb: appCleanup,
        windowTitle: "ryurei",
        width: 400,
        height: 300,
        icon: IconDesc(sokol_default: true),
        logger: sokol_app.Logger(fn: sokol_log.fn),
      )
    )

template plugin*(name, body: untyped) =
  type name* = object

  proc build*(P: typedesc[name], world {.inject.}: var World) =
    body
