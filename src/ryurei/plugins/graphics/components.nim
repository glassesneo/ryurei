import pkg/seiryu

type Point* = object

func init*(T: type Point): T {.construct.}
