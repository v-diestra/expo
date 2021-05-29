require_relative 'Constants'

module Pod
  class Installer
    class Xcode
      class MultiPodsProjectGenerator
        private

        include Expo::Constants

        _originalGenerateMethod = instance_method(:generate!)

        public

        define_method(:generate!) do
          generatorResults = _originalGenerateMethod.bind(self).()

          # Pods.xcodeproj
          podsProject = generatorResults.project

          aggregate_targets.each do |target|
            # puts target.target_definition.autolinkingManager, target.support_files_dir

            # Path to `Pods/Target Support Files/<pods target name>/<modules provider file>`
            modulesProviderPath = File.join(
              target.support_files_dir,
              MODULES_PROVIDER_FILE_NAME
            )

            # Xcode's PBXGroup for generated files (should we make it Expo-specific?)
            # generatedGroup = userProject.main_group.groups.find { |group| group.name == GENERATED_GROUP_NAME } || userProject.new_group(GENERATED_GROUP_NAME)
            generatedGroup = podsProject.support_files_group.find_subpath(target.name)

            # puts "GENERATED FILES:", generatedGroup.files.inspect

            # PBXGroup uses relative paths, so we need to strip the absolute path
            modulesProviderRelativePath = Pathname.new(modulesProviderPath).relative_path_from(generatedGroup.real_path).to_s

            # Create new PBXFileReference if the modules provider is not in the group yet
            if generatedGroup.find_file_by_path(modulesProviderRelativePath).nil?
              modulesProviderFileReference = generatedGroup.new_file(modulesProviderPath)

              nativeTarget = podsProject.native_targets.find { |nativeTarget| nativeTarget.name == target.name }
              nativeTarget.add_file_references([modulesProviderFileReference])
            end
          end

          puts podsProject.native_targets[0].inspect

          generatorResults
        end
      end
    end
  end
end
