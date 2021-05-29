
module Pod
  class Podfile
    class TargetDefinition
      public
      attr_reader :autolinkingManager

      def autolinkingManager=(autolinkingManager)
        @autolinkingManager = autolinkingManager
      end

      def autolinkingManager
        if @autolinkingManager.present? || parent.nil?
          @autolinkingManager
        else
          parent.autolinkingManager
        end
      end
    end
  end
end
