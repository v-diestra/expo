protocol AnyExportedMethod {
  var argumentsCount: Int { get }

  func call(args: Any, promise: Promise) -> Void
}

@propertyWrapper
struct ExportMethod<Args, ReturnType>: AnyExportedMethod {
  typealias MethodType = (Args) -> ReturnType

  var wrappedValue: MethodType
  var takesPromise: Bool
  var argumentsCount: Int

  init(wrappedValue: @escaping MethodType) {
    let components = String(describing: Args.self).components(separatedBy: ", ")

    self.wrappedValue = wrappedValue
    self.takesPromise = components.last == "Promise)"
    self.argumentsCount = components.count - (takesPromise ? 1 : 0)
  }

  func call(args: Any, promise: Promise) {
    guard let array = args as? [Any] else {
      promise.resolve(wrappedValue(args as! Args))
      return
    }

    let arrayWithPromise = array + (takesPromise ? [promise] : [])
    let tuple: Args = Conversions.arrayToTuple(arrayWithPromise) as! Args
    let returnedValue = wrappedValue(tuple)

    // Immediately resolve with the returned value when the method doesn't take the promise as an argument.
    if !takesPromise {
      promise.resolve(returnedValue)
    }
  }
}
