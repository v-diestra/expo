
public class ModuleRegistry: Sequence {
  private var registry: [String: ModuleHolder] = [:]

  init(withProvider provider: ModulesProvider) {
    provider.exportedModules().forEach { module in
      register(module: module)
    }
  }

  func register(module: Module) {
    registry[module.name] = ModuleHolder(module: module)
  }

  func has(moduleWithName moduleName: String) -> Bool {
    return registry[moduleName] != nil
  }

  func get(moduleHolderForName moduleName: String) -> ModuleHolder? {
    return registry[moduleName]
  }

  func get(moduleWithName moduleName: String) -> Module? {
    return registry[moduleName]?.module
  }

  public func makeIterator() -> IndexingIterator<[ModuleHolder]> {
    return registry.map({ $1 }).makeIterator()
  }
}
