import std/colors
import std/lenientops
import ../src/ryurei
import ../src/ryurei/plugins/graphics/graphics

var app = Application.init()

app.loadPlugin(GraphicsPlugin)

app.run:
  for i in 0 ..< 30:
    let entity = world.spawnEntity()
    world.attachComponents(
      entity,
      (
        Point(),
        Transform2D.init(position = dvec2(10f * (i + 1), 50f)),
        RyureiColor.init(colYellow),
      ),
    )

  for i in 0 ..< 2:
    let entity = world.spawnEntity()
    world.attachComponents(
      entity,
      (
        Line(size: dvec2(0, -30)),
        Transform2D.init(position = dvec2(20f * (i + 1), 150f)),
        RyureiColor.init(colGreen),
      ),
    )

  for i in 0 ..< 1:
    let entity = world.spawnEntity()
    world.attachComponents(
      entity,
      (
        Rectangle(size: dvec2(10, 10)),
        Transform2D.init(position = dvec2(30f * (i + 1), 200f)),
        RyureiColor.init(colBlue),
      ),
    )
