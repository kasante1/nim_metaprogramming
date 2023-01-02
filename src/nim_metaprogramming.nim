import macros

when isMainModule:
  echo("Hello, World!")

  type
    Person = object
      name: string
      age: int

  static:
    for sym in getType(Person)[2]:
      echo(sym.strVal)

  # generics

  proc myMax[T](a, b: T): T = 
    if a < b:
      return b
    else:
      return a
  doAssert myMax(5, 10) == 10
  doAssert myMax(31.3, 1.23) == 31.3

  type
    Container[T] = object
      empty: bool
      value: T

  proc initContainer[T]() : Container[T] = 
    result.empty = true

  var myBox = initContainer[string]()

  # constraining generics

  proc myOtherMax[T: int | float](a, b: T): T =
    if a < b:
      return b
    else:
      return a

  echo myOtherMax(8, 7)

  # type definition for multiple types

  type
    Number = int | float | uint

  proc isPositive(x: Number): bool = 
    return x > 0

  doAssert isPositive(2) == true

  template declareVar(varName: untyped, value: typed) = 
    var varName = value

  declareVar(foo, 42)

  echo(foo)

  # template hygiene getting access to variables 
  # in the scope

  template hygiene(varName: untyped) =
    var varName = 42
    var notInjected = 128
    var injected {.inject.} = notInjected + 2


  hygiene(injectedImplicitly)

  doAssert(injectedImplicitly == 42)
  doAssert(injected == 130)
  # doAssert(notInjected == 128)

  proc fillString(): string =
    result = " " 
    echo("generating string")
    for i in 0 .. 7:
      result.add($i)
  
  const count = fillString()