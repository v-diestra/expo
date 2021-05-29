
public protocol Module {
  var name: String { get }

  func constantsToExport() -> [String: Any]?
}

extension Module {
  public var name: String {
    return String(describing: type(of: self))
  }

  public func constantsToExport() -> [String: Any]? {
    return nil
  }
}

open class BaseModule: Module {
  public func constantsToExport() -> [String : Any]? {
    return [
      "exportedConstant": 2137
    ]
  }

  public init() {}

  @ExportMethod
  var add = { (a: Int, b: Double) -> Double in
    return Double(a) + b
  }

  @ExportMethod
  var subtract = { (a: Int, b: Double, promise: Promise) in
    promise.resolve(Double(a) - b)
  }
}
