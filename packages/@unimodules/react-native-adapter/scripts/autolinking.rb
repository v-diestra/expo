require 'json'
require 'pathname'

require_relative 'cocoapods/AutolinkingManager'
require_relative 'cocoapods/Podfile'
require_relative 'cocoapods/TargetDefinition'
# require_relative 'cocoapods/Installer'
require_relative 'cocoapods/UserProjectIntegrator'

def use_expo_modules!(custom_options = {})
  # When run from the Podfile, `self` points to Pod::Podfile object

  Expo::AutolinkingManager.new(self, @current_target_definition).useExpoModules!(custom_options)
end
