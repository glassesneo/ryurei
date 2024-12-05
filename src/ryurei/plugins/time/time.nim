import pkg/rulecs
import ../../core/application
import resources, systems

plugin TimePlugin:
  world.addResource(Clock.init(targetFPS = 30))
  world.registerRuntimeSystemsAt(First, countFrame)
  world.registerRuntimeSystemsAt(PostProcess, manageFrameRate)

export resources
