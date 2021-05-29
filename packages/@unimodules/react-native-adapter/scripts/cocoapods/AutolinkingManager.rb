require_relative 'Colors'

module Expo
  class AutolinkingManager
    def initialize(podfile, current_target_definition)
      @podfile = podfile
      @current_target_definition = current_target_definition

      current_target_definition.autolinkingManager = self
    end

    def useExpoModules!(options = {})
      json = resolve(options)
      modules = json['modules']

      puts @current_target_definition
      if modules.nil?
        return
      end

      globalFlags = options.fetch(:flags, {})
      tests = options.fetch(:tests, [])

      projectDirectory = Pod::Config.instance.project_root

      puts "Using expo modules"

      modules.each { |expoModule|
        packageName = expoModule['packageName']
        packageVersion = expoModule['packageVersion']
        podName = expoModule['podName']
        podPath = expoModule['podspecDir']
        flags = expoModule.fetch('flags', {})

        # The module can already be added to the target, in which case we can just skip it.
        # This allows us to add a pod before `use_expo_modules` to provide custom flags.
        if @current_target_definition.dependencies.any? { |dependency| dependency.name == podName }
          puts "— #{Colors.GREEN}#{packageName}#{Colors.RESET} #{Colors.YELLOW}is already added to the target#{Colors.RESET}"
          next
        end

        podOptions = {
          :path => Pathname.new(podPath).relative_path_from(projectDirectory).to_path,
          :testspecs => tests.include?(packageName) ? ['Tests'] : []
        }.merge(globalFlags, flags)

        # Install the pod.
        @podfile.pod podName, podOptions

        # Can remove this once we move all the interfaces into the core.
        next if podName.end_with?('Interface')

        puts "— #{Colors.GREEN}#{packageName}#{Colors.RESET} (#{packageVersion})"
      }
    end

    private

    def resolve(options)
      args = convertFindOptionsToArgs(options)
      json = []

      IO.popen(args) do |data|
        while line = data.gets
          json << line
        end
      end

      begin
        JSON.parse(json.join())
      rescue => error
        raise "Couldn't parse JSON coming from `expo-modules-autolinking` command:\n#{error}"
      end
    end

    def convertFindOptionsToArgs(options)
      searchPaths = options.fetch(:searchPaths, options.fetch(:modules_paths, nil))
      ignorePaths = options.fetch(:ignorePaths, nil)
      exclude = options.fetch(:exclude, [])

      packageListTargetPath = File.join(
        File.dirname(@podfile.defined_in_file),
        'Pods',
        'Target Support Files',
        'UMCore',
        'ExpoSwiftModulesProvider.swift'
      )

      args = [
        'node',
        '--eval',
        'require(\'expo-modules-autolinking\')(process.argv.slice(1))',
        'resolve',
        '--json',
        '--platform',
        'ios',
        '--package-list-target',
        packageListTargetPath
      ]

      if !searchPaths.nil? && !searchPaths.empty?
        args.concat(searchPaths)
      end

      if !ignorePaths.nil? && !ignorePaths.empty?
        args.concat(['--ignore-paths'], ignorePaths)
      end

      if !exclude.nil? && !exclude.empty?
        args.concat(['--exclude'], exclude)
      end

      args
    end
  end # class AutolinkingManager
end # module Expo
