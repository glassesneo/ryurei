import std/random
import ../src/ryurei
import ../src/ryurei/plugins/time/time
import ../src/ryurei/plugins/graphics/graphics

type Velocity = object
  x, y: float

var app = Application.init()

app.loadPlugin(TimePlugin)
app.loadPlugin(GraphicsPlugin)

func setup(clock: Res[ptr Clock]) {.system.} =
  clock[].targetFPS = 60

func showFPS(clock: Res[Clock]) {.system.} =
  debugEcho clock.fps

func generateSystem() {.system.} =
  let entity = control.spawnEntity()
  control.attachComponents(
    entity,
    (
      Transform2D.init(position = dvec2(0f, 0f)),
      Velocity(x: rand(0f .. 50f), y: rand(0f .. 50f)),
      Rectangle.init(size = dvec2(10, 10)),
      RyureiColor.init(rand(255).uint8, rand(255).uint8, rand(255).uint8),
    ),
  )

func moveSystem(movables: [All[Transform2D, Velocity]], clock: Res[Clock]) {.system.} =
  let frame = clock.averageFrameTime()
  for entity, tf, vel in movables of (ptr Transform2D, Velocity):
    tf.position.x += vel.x * frame
    tf.position.y += vel.y * frame

app.run:
  world.registerStartupSystems(setup)
  world.registerRuntimeSystemsAt(PreUpdate, generateSystem)
  world.registerRuntimeSystemsAt(Update, moveSystem)
  world.registerRuntimeSystemsAt(Update, showFPS)
