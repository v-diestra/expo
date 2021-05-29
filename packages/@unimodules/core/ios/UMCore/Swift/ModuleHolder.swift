
public struct ModuleHolder {
  var module: Module
  var methods = [String: AnyExportedMethod]()

  init(module: Module) {
    self.module = module

    let mirror = Mirror(reflecting: module)

    for child in mirror.children {
      if let value = child.value as? AnyExportedMethod, let label = child.label {
        // Wrapped properties have `_` before the original name
        let methodName = String(label.dropFirst())
        methods[methodName] = value
      }
    }
  }

  func call(method methodName: String, args: Any, promise: Promise) {
    methods[methodName]?.call(args: args, promise: promise)
  }
}
