module SettingsSpec
  module Visitors
    module String

      def match(regexp)
        return false unless @setting.is_a? ::String
        !!regexp.match(@setting)
      end

    end
  end
end
