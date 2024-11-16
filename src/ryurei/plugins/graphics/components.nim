import pkg/seiryu
import pkg/vmath

type
  Point* = object

  Line* = object
    size*: DVec2

  Rectangle* = object
    size*: DVec2

func init*(T: type Point): T {.construct.}
func init*(T: type Line, size: DVec2): T {.construct.}
func init*(T: type Rectangle, size: DVec2): T {.construct.}
