module SettingsSpec
  module Visitors
    module Number

      def gt(n)
        return false unless @setting.is_a? Integer
        @setting > n
      end

      def lt(n)
        return false unless @setting.is_a? Integer
        @setting < n
      end

    end
  end
end
