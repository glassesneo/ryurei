{.experimental: "strictFuncs".}
{.experimental: "strictDefs".}
{.experimental: "views".}

import std/colors
import pkg/seiryu
import pkg/vmath

type
  Transform2D* = object
    position*: DVec2
    rotation*: float
    scale*: DVec2

  RyureiColor* = object
    r*, g*, b*, a*: uint8

func init*(
  T: type Transform2D, position = dvec2(0f, 0f), rotation = 0f, scale = dvec2(0f, 0f)
): T {.construct.}

func init*(T: type RyureiColor, r, g, b: uint8, a: uint8 = 255): T {.construct.}

func init*(T: type RyureiColor, color: colors.Color): T =
  let (r, g, b) = color.extractRGB()
  return RyureiColor.init(r.uint8, g.uint8, b.uint8)
