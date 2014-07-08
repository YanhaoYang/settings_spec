module SettingsSpec
  class Specs

    # A Hash whose keys are the keys of the invalid entries joined by "."
    attr_reader :errors

    def initialize(specs)
      @specs = specs
      @errors = {}
    end

    # Verifies the +settings+ against the specifications having been loaded.
    #
    # +settings+ can be a Hash, or any object responding to <tt>:[]</tt> or
    # keys in the settings.
    #
    # Returns +true+ if there is no error, +false+ if there are errors. Errors can
    # be accessed by <tt>Specs#errors</tt>.
    def verify(settings)
      if settings
        check([], @specs, settings)
      else
        @errors['.'] = 'Settings is a nil?!'
      end
      @errors.empty?
    end

    # Same as <tt>Specs#verify</tt>, but raises an exception when the settings are invalid.
    def verify!(settings)
      verify(settings)
      unless @errors.empty?
        error_messages = []
        @errors.each do |k, v|
          error_messages << %{  %s: "%s"} % [k, v]
        end
        raise StandardError, "Some settings do not pass verification:\n#{error_messages.join("\n")}"
      end
    end

    private

      def check(path, spec_node, setting_node)
        case spec_node
          when Hash
        else
        end
        case spec_node
        when Hash
          spec_node.each do |k, v|
            check(path + [k], v, fetch(setting_node, k))
          end
        when String
          begin
            unless Visitor.new(setting_node).visit(spec_node)
              @errors[path.join(':')] = "#{spec_node} [val: #{setting_node}]"
            end
          rescue
              @errors[path.join(':')] = "#{spec_node} [exception: #{$!}]"
          end
        else
          raise InvalidSpec, "#{path.join('.')}: #{spec_node.to_s} (It should be a String.)"
        end
      end

      def getters
        @getters ||= [
          lambda { |obj, key| obj[key.to_s] rescue nil if obj.respond_to?(:'[]')},
          lambda { |obj, key| obj[key.to_sym] rescue nil if obj.respond_to?(:'[]')},
          lambda { |obj, key| obj.send(key.to_sym) rescue nil},
        ]
      end

      def fetch(settings, key)
        return unless settings

        getters.each do |getter|
          val = getter.call(settings, key)
          return val unless val.nil?
        end
        return nil
      end

  end
end
