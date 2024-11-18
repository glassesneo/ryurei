import std/os
import pkg/sokol/time as sokol_time
import pkg/rulecs
import resources

func countFrame*(clock: Res[ptr Clock]) {.system.} =
  clock[].computeDeltaTime()
  clock[].update()

func manageFrameRate*(clock: Res[ptr Clock]) {.system.} =
  let currentTicks = sokol_time.now()
  let endFrameTime = sokol_time.sec(sokol_time.diff(currentTicks, clock[].lastTicks))
  let margin = clock[].frameTime - endFrameTime
  if margin > 0:
    sleep(int(margin * 1000))
