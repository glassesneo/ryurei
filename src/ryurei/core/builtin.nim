import std/tables
import pkg/rulecs
import pkg/seiryu
import pkg/seiryu/sugar
import pkg/sokol/app as sokol_app
import ./plugin

type KeyboardInput* = object
  downKeys, releasedKeys: set[Keycode]
  heldFrameMap: Table[Keycode, Natural]

func init*(T: type KeyboardInput): T {.construct.}

func downKeys*(input: KeyboardInput): set[Keycode] {.getter.}

func releasedKeys*(input: KeyboardInput): set[Keycode] {.getter.}

func heldFrameMap*(input: KeyboardInput): Table[Keycode, Natural] {.getter.}

func readApplicationEvent*(world: var World, event: ptr sokol_app.Event) =
  case event.type
  of eventTypeKeyDown:
    with world.mutableResourceOf(KeyboardInput) as keyboardInput:
      if not event.keyRepeat:
        keyboardInput.downKeys.incl event.keyCode
        keyboardInput.heldFrameMap[event.keyCode] = 1
  of eventTypeKeyUp:
    with world.mutableResourceOf(KeyboardInput) as keyboardInput:
      keyboardInput.downKeys.excl event.keyCode
      keyboardInput.heldFrameMap[event.keyCode] = 0
      keyboardInput.releasedKeys.incl event.keyCode
  else:
    discard

func updateApplicationEvent(keyboardInput: Res[ptr KeyboardInput]) {.system.} =
  for keyCode in keyboardInput.downKeys:
    if keyboardInput.heldFrameMap[keyCode] == 1:
      keyboardInput.heldFrameMap[keyCode] += 1
  keyboardInput.releasedKeys = {}

func `[]`*(table: Table[Keycode, Natural], keyCode: Keycode): Natural =
  return table.getOrDefault(keyCode, 0)

func currentFps*(): float =
  return 1f / sokol_app.frameDuration()

func frameDuration*(): float =
  return sokol_app.frameDuration()

func frameCount*(): uint =
  return sokol_app.frameCount()

plugin BuiltinPlugin:
  world.addResource(KeyboardInput.init())
  world.registerRuntimeSystemsAt(PostProcess, updateApplicationEvent)
