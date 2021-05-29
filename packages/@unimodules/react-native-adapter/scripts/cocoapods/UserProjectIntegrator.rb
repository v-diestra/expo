require_relative 'Constants'

module Pod
  class Installer
    class UserProjectIntegrator
      private

      include Expo::Constants

      _originalIntegrateUserTargets = instance_method(:integrate_user_targets)

      # Integrates the targets of the user projects with the libraries
      # generated from the {Podfile}.
      #
      # @note   {TargetDefinition} without dependencies are skipped prevent
      #         creating empty libraries for targets definitions which are only
      #         wrappers for others.
      #
      # @return [void]
      #
      define_method(:integrate_user_targets) do
        # Call original method first
        results = _originalIntegrateUserTargets.bind(self).()

        targets_to_integrate.sort_by(&:name).each do |target|
          # The user project
          project = target.user_project

          # The user target name (without `Pods-` prefix which is a part of `target.name`)
          targetName = target.target_definition.name

          # PBXNativeTarget of the user target
          nativeTarget = project.native_targets.find { |nativeTarget| nativeTarget.name == targetName }

          # Absolute path to `Pods/Target Support Files/<pods target name>/<modules provider file>` within the project path
          modulesProviderPath = File.join(
            target.support_files_dir,
            MODULES_PROVIDER_FILE_NAME
          )

          # Xcode's PBXGroup for generated files
          generatedGroup = project.main_group.find_subpath(GENERATED_GROUP_NAME, true)

          # PBXGroup for generated files per target
          generatedTargetGroup = generatedGroup.find_subpath(targetName, true)
          
          # Remove existing references in the target group
          generatedTargetGroup.clear

          # PBXGroup uses relative paths, so we need to strip the absolute path
          modulesProviderRelativePath = Pathname.new(modulesProviderPath).relative_path_from(generatedTargetGroup.real_path).to_s

          # Create new PBXFileReference if the modules provider is not in the group yet
          if generatedTargetGroup.find_file_by_path(modulesProviderRelativePath).nil?
            modulesProviderFileReference = generatedTargetGroup.new_file(modulesProviderPath)

            if nativeTarget.source_build_phase.files_references.find { |ref| ref.path == modulesProviderRelativePath }.nil?
              nativeTarget.add_file_references([modulesProviderFileReference])
            end
          end
        end

        results
      end

    end # class UserProjectIntegrator
  end # class Installer
end # module Pod
