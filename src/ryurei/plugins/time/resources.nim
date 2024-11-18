import std/lenientops
import pkg/sokol/app as sokol_app
import pkg/sokol/time as sokol_time
import pkg/seiryu

type Clock* = object
  targetFPS: Natural
  frameTime, deltaTime: float64
  lastTicks: uint64
  fps: float
  secCount: float64
  frameCount: Natural

func init*(T: type Clock, targetFPS: Natural): T {.construct.} =
  result.targetFPS = targetFPS
  result.fps = float targetFPS
  result.frameTime = 1 / targetFPS

func computeDeltaTime*(clock: var Clock) =
  let currentTicks = sokol_time.now()
  clock.deltaTime = sokol_time.sec(sokol_time.diff(currentTicks, clock.lastTicks))
  clock.lastTicks = currentTicks

func update*(clock: var Clock) =
  clock.frameCount += 1
  clock.secCount += clock.deltaTime

  if clock.secCount > 1.0:
    clock.fps = clock.frameCount / clock.secCount
    clock.frameCount = 0
    clock.secCount = 0

func targetFPS*(clock: Clock): lent Natural {.getter.}

func `targetFPS=`*(clock: var Clock, value: range[1 .. 60]) =
  clock.targetFPS = value
  clock.fps = float value
  clock.frameTime = 1 / value

func frameTime*(clock: Clock): lent float64 {.getter.}

func deltaTime*(clock: Clock): lent float64 {.getter.}

func averageFrameTime*(clock: Clock): float64 =
  sokol_app.frameDuration()

func lastTicks*(clock: Clock): lent uint64 {.getter.}

func fps*(clock: Clock): lent float {.getter.}

func secCount*(clock: Clock): lent float64 {.getter.}

func frameCount*(clock: Clock): lent Natural {.getter.}
