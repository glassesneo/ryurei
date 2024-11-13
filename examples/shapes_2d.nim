import std/colors
import ../src/ryurei
import ../src/ryurei/plugins/graphics/graphics

var app = Application.init()

app.loadPlugin(GraphicsPlugin)

app.run:
  let entity = world.spawnEntity()
  world.attachComponents(
    entity,
    (Transform2D.init(position = dvec2(100f, 50f)), Point(), RyureiColor.init(colBlue)),
  )
