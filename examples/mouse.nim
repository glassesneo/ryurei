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

func generateSystem(mouseInput: Res[MouseInput]) {.system.} =
  if mouseInput.heldFrameMap[ord mouseButtonLeft] != 1:
    return

  let entity = control.spawnEntity()
  control.attachComponents(
    entity,
    (
      Transform2D.init(position = mouseInput.position),
      Velocity(x: rand(-50f .. 50f), y: rand(-50f .. 50f)),
      Rectangle.init(size = dvec2(10, 10)),
      RyureiColor.init(rand(255).uint8, rand(255).uint8, rand(255).uint8),
    ),
  )

func moveSystem(movables: [All[Transform2D, Velocity]]) {.system.} =
  let frame = frameDuration()
  for entity, tf, vel in movables of (ptr Transform2D, Velocity):
    tf.position.x += vel.x * frame
    tf.position.y += vel.y * frame

app.run:
  world.registerStartupSystems(setup)
  world.registerRuntimeSystemsAt(PreUpdate, generateSystem)
  world.registerRuntimeSystemsAt(Update, moveSystem)
