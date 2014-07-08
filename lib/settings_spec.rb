require "settings_spec/version"
require "settings_spec/specs"
require "settings_spec/visitor"
require 'yaml'

module SettingsSpec

  class InvalidSpec < StandardError; end

  # Loads specifications from +spec_file+, a YAML file. The +spec_file+ can be
  # composed of several sections for different environments, like:
  #
  #   defaults: &defaults
  #     ...
  #   development:
  #     <<: *defaults
  #     ...
  #   test:
  #     <<: *defaults
  #     ...
  #
  # +namespace+ is used to specify the environment. In a Rails application, it
  # may be +Rails.env+ usually.
  #
  def self.load(spec_file, namespace)
    specs = YAML.load_file(spec_file)
    specs = specs[namespace] if namespace
    Specs.new(specs)
  end

end
