import std/sets
import pkg/rulecs
import pkg/seiryu
import pkg/seiryu/sugar
import pkg/sokol/app as sokol_app
import pkg/vmath
import ./plugin

type KeyboardInput* = object
  downKeys, releasedKeys: HashSet[Keycode]
  heldFrameMap: seq[Natural]

func init*(T: type KeyboardInput): T {.construct.} =
  result.downKeys = initHashSet[Keycode]()
  result.releasedKeys = initHashSet[Keycode]()
  result.heldFrameMap = newSeq[Natural](len = keyCodeMenu.int)

func downKeys*(input: KeyboardInput): HashSet[Keycode] {.getter.}

func releasedKeys*(input: KeyboardInput): HashSet[Keycode] {.getter.}

func heldFrameMap*(input: KeyboardInput): seq[Natural] {.getter.}

type MouseInput* = object
  downButtons, releasedButtons: HashSet[Mousebutton]
  heldFrameMap: seq[Natural]
  position: DVec2

func init*(T: type MouseInput): T {.construct.} =
  result.downButtons = initHashSet[Mousebutton]()
  result.releasedButtons = initHashSet[Mousebutton]()
  result.heldFrameMap = newSeq[Natural](len = mouseButtonInvalid.int)

func downButtons*(input: MouseInput): HashSet[Mousebutton] {.getter.}

func releasedButtons*(input: MouseInput): HashSet[Mousebutton] {.getter.}

func heldFrameMap*(input: MouseInput): seq[Natural] {.getter.}

func position*(input: MouseInput): DVec2 {.getter.}

func readApplicationEvent*(world: var World, event: ptr sokol_app.Event) =
  case event.type
  of eventTypeKeyDown:
    with world.mutableResourceOf(KeyboardInput) as keyboardInput:
      if not event.keyRepeat:
        keyboardInput.downKeys.incl event.keyCode
        keyboardInput.heldFrameMap[ord event.keyCode] = 1
  of eventTypeKeyUp:
    with world.mutableResourceOf(KeyboardInput) as keyboardInput:
      keyboardInput.downKeys.excl event.keyCode
      keyboardInput.heldFrameMap[ord event.keyCode] = 0
      keyboardInput.releasedKeys.incl event.keyCode
  of eventTypeMouseDown:
    with world.mutableResourceOf(MouseInput) as mouseInput:
      let index = ord event.mouseButton
      if mouseInput.heldFrameMap[index] == 0:
        mouseInput.downButtons.incl event.mouseButton
        mouseInput.heldFrameMap[index] = 1
  of eventTypeMouseUp:
    with world.mutableResourceOf(MouseInput) as mouseInput:
      let index = ord event.mouseButton
      mouseInput.downButtons.excl event.mouseButton
      mouseInput.heldFrameMap[index] = 0
      mouseInput.releasedButtons.incl event.mouseButton
  of eventTypeMouseMove:
    with world.mutableResourceOf(MouseInput) as mouseInput:
      mouseInput.position.x = event.mouseX
      mouseInput.position.y = event.mouseY
  else:
    discard

func updateApplicationEvent(
    keyboardInput: Res[ptr KeyboardInput], mouseInput: Res[ptr MouseInput]
) {.system.} =
  for keyCode in keyboardInput.downKeys:
    let index = ord keyCode
    if keyboardInput.heldFrameMap[index] >= 1:
      keyboardInput.heldFrameMap[index] += 1
  keyboardInput.releasedKeys.clear()

  for mouseButton in mouseInput.downButtons:
    let index = ord mouseButton
    if mouseInput.heldFrameMap[index] >= 1:
      mouseInput.heldFrameMap[index] += 1
  mouseInput.releasedButtons.clear()

func currentFps*(): float =
  return 1f / sokol_app.frameDuration()

func frameDuration*(): float =
  return sokol_app.frameDuration()

func frameCount*(): uint64 =
  return sokol_app.frameCount()

plugin BuiltinPlugin:
  world.addResource(KeyboardInput.init())
  world.addResource(MouseInput.init())
  world.registerRuntimeSystemsAt(PostProcess, updateApplicationEvent)
