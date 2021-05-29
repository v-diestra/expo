
@objc
public class ExpoModulesProvider: ModulesProvider {
  override func exportedModules() -> [Module] {
    return [
      BaseModule()
    ]
  }
}
