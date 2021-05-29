require_relative 'Constants'

# To properly set user's Xcode project we need to use `pre_install` hook,
# but doing this in the Podfile context would disallow the user to redefine it
# as CocoaPods supports defining only one hook for specific type.
# To make it transparent for the user, we're forced to override Podfile's methods.
module Pod
  class Podfile
    private

    include Expo::Constants

    # # Save original method
    # _originalPreInstall = instance_method(:pre_install!)

    # public

    # define_method(:pre_install!) do |installer|
    #   puts "CALLED OVERRIDEN pre_install", installer.pods_project.inspect

    #   installer.aggregate_targets.each  do |target|
    #     # puts target.target_definition.autolinkingManager, target.support_files_dir

    #     # Temporary naive way to access the user's project
    #     userProject = target.user_project

    #     # Path to `Pods/Target Support Files/<pods target name>`
    #     supportFilesDir = installer.sandbox.target_support_files_dir(target.name)

    #     # Path to the modules provider file within support files
    #     modulesProviderPath = File.join(supportFilesDir, MODULES_PROVIDER_FILE_NAME)

    #     # Xcode's PBXGroup for generated files (should we make it Expo-specific?)
    #     # generatedGroup = userProject.main_group.groups.find { |group| group.name == GENERATED_GROUP_NAME } || userProject.new_group(GENERATED_GROUP_NAME)
    #     generatedGroup = userProject.main_group.find_subpath("#{GENERATED_GROUP_NAME}/#{target.target_definition.name}", true)

    #     # puts "GENERATED FILES:", generatedGroup.files.inspect

    #     # PBXGroup uses relative paths, so we need to strip the absolute path
    #     modulesProviderRelativePath = Pathname.new(modulesProviderPath).relative_path_from(generatedGroup.real_path).to_s

    #     # Create new PBXFileReference if the modules provider is not in the group yet
    #     if generatedGroup.find_file_by_path(modulesProviderRelativePath).nil?
    #       generatedGroup.new_file(modulesProviderPath)
    #     end
    #   end

    #   # Run the original pre_install
    #   _originalPreInstall.bind(self).(installer)
    # end
  end
end
