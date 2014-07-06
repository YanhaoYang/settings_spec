module SettingsSpec
  module Visitors
    module Common

      def blank
        @setting.respond_to?(:empty?) ? @setting.empty? : !@setting
      end

      def is_a(klass)
        @setting.is_a? klass
      end

      def call(proc)
        proc.call(@setting)
      end

    end
  end
end
