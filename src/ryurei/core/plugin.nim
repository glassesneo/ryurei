import std/macros
import std/macrocache
import std/typetraits
import pkg/rulecs

const PluginRegistry = CacheTable"PluginRegistry"

type Plugin* =
  concept type P
      P.build(var World)

func isAlreadyRegistered*[T: Plugin](P: typedesc[T]): bool =
  return typetraits.name(P) in PluginRegistry

macro registerPlugin*[T: Plugin](P: typedesc[T]) =
  PluginRegistry[P.strVal] = P

template plugin*(name, body: untyped) =
  type name* = object

  proc build*(P: typedesc[name], world {.inject.}: var World) =
    body
