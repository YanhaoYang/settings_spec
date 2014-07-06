require 'spec_helper'
require 'library_specs'

module Rails
  class Engine
    def self.isolate_namespace(mod)
    end
  end
end

require 'rails_config'

describe SettingsSpec do

  let(:settings) do
    ->(name) do
      fn = File.dirname(__FILE__) + "/../fixtures/#{name}.yml"
      RailsConfig.load_and_set_settings fn
      Settings.development
    end
  end

  describe "#RailsConfig" do
    include_examples 'configuration library'
  end

end
