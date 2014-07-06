require "settings_spec/version"
require "settings_spec/specs"
require "settings_spec/visitor"
require 'yaml'

module SettingsSpec

  class InvalidSpec < StandardError; end

  def self.load(spec_file, namespace)
    specs = YAML.load_file(spec_file)
    specs = specs[namespace] if namespace
    Specs.new(specs)
  end

end
