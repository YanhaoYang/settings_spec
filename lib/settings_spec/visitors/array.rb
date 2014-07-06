module SettingsSpec
  module Visitors
    module Array

      def one_in(array_or_range)
        array_or_range.include?(@setting)
      end

      def all_in(array_or_range)
        return false unless @setting.is_a? ::Array
        @setting.all? { |i| array_or_range.include?(i) }
      end

    end
  end
end
