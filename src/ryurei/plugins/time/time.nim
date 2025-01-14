import std/lenientops
import std/os
import pkg/rulecs
import pkg/sokol/app as sokol_app
import pkg/sokol/time as sokol_time
import pkg/seiryu
import ../../core/application

type Clock* = object
  targetFPS: Natural
  frameTime, deltaTime: float64
  lastTicks: uint64

func init(T: type Clock, targetFPS: Natural): T {.construct.} =
  result.targetFPS = targetFPS
  result.frameTime = 1 / targetFPS

func targetFPS*(clock: Clock): lent Natural {.getter.}

func `targetFPS=`*(clock: var Clock, value: range[1 .. 60]) =
  clock.targetFPS = value
  clock.frameTime = 1 / value

func frameTime*(clock: Clock): lent float64 {.getter.}

func deltaTime*(clock: Clock): lent float64 {.getter.}

func lastTicks*(clock: Clock): lent uint64 {.getter.}

func countFrame(clock: Res[ptr Clock]) {.system.} =
  let currentTicks = sokol_time.now()
  clock.deltaTime = sokol_time.sec(sokol_time.diff(currentTicks, clock.lastTicks))
  clock.lastTicks = currentTicks

func manageFrameRate(clock: Res[ptr Clock]) {.system.} =
  let currentTicks = sokol_time.now()
  let endFrameTime = sokol_time.sec(sokol_time.diff(currentTicks, clock.lastTicks))
  let margin = clock.frameTime - endFrameTime
  if margin > 0:
    sleep(int(margin * 1000))

plugin TimePlugin:
  world.addResource(Clock.init(targetFPS = 30))
  world.registerRuntimeSystemsAt(First, countFrame)
  world.registerRuntimeSystemsAt(PostProcess, manageFrameRate)
