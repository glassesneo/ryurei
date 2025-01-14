{.experimental: "strictFuncs".}
{.experimental: "strictDefs".}
{.experimental: "views".}

import std/typetraits
import pkg/rulecs
import pkg/seiryu
import
  pkg/sokol/app as sokol_app,
  pkg/sokol/log as sokol_log,
  pkg/sokol/gfx as sokol_gfx,
  pkg/sokol/glue as sokol_glue,
  pkg/sokol/gl as sokol_gl,
  pkg/sokol/time as sokol_time
import ./builtin
import ./plugin

type Application* = object
  world*: World

func init*(T: type Application): T {.construct.} =
  result.world = World.init()

template loadPlugin*[T: Plugin](app: var Application, P: typedesc[T]) =
  when P.isAlreadyRegistered():
    {.warning: "duplicate plugin: " & typetraits.name(`P`).}
  else:
    registerPlugin(P)
    P.build(app.world)

template run*(app: var Application, body: untyped) =
  block:
    template world(): World {.used, inject.} =
      app.world

    proc appInit() {.cdecl.} =
      sokol_time.setup()
      sokol_gfx.setup(
        sokol_gfx.Desc(
          environment: sokol_glue.environment(),
          logger: sokol_gfx.Logger(fn: sokol_log.fn),
        )
      )
      sokol_gl.setup(sokol_gl.Desc(logger: sokol_gl.Logger(fn: sokol_log.fn)))
      app.loadPlugin(BuiltinPlugin)
      body
      app.world.setupSystems()
      app.world.performStartupSystems()

    proc appFrame() {.cdecl.} =
      app.world.performRuntimeSystems()

    proc appEvent(event: ptr sokol_app.Event) {.cdecl.} =
      app.world.readApplicationEvent(event)

    proc appCleanup() {.cdecl.} =
      app.world.performTerminateSystems()
      sokol_gl.shutdown()
      sokol_gfx.shutdown()

    sokol_app.run(
      sokol_app.Desc(
        initCb: appInit,
        frameCb: appFrame,
        eventCb: appEvent,
        cleanupCb: appCleanup,
        windowTitle: "ryurei",
        width: 400,
        height: 300,
        icon: IconDesc(sokol_default: true),
        logger: sokol_app.Logger(fn: sokol_log.fn),
      )
    )

export builtin
export plugin.Plugin, plugin.plugin
