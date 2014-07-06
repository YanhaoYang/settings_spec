require "settings_spec/visitors/common"
require "settings_spec/visitors/number"
require "settings_spec/visitors/string"
require "settings_spec/visitors/array"

module SettingsSpec
  class Visitor
    include Visitors::Common
    include Visitors::Number
    include Visitors::String
    include Visitors::Array

    def initialize(setting)
      @setting = setting
    end

    def visit(spec)
      instance_eval(spec)
    end

  end
end
