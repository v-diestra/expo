
protocol ModulesProviderProtocol {
  func exportedModules() -> [Module]
}

@objc
protocol ModulesProviderObjCProtocol {}

@objc
open class ModulesProvider: NSObject, ModulesProviderProtocol, ModulesProviderObjCProtocol {
  func exportedModules() -> [Module] {
    return []
  }
}
