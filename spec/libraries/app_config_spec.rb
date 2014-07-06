require 'spec_helper'
require 'library_specs'
require 'app_config'

describe SettingsSpec do

  let(:settings) do
    ->(name) do
      fn = File.dirname(__FILE__) + "/../fixtures/#{name}.yml"
      AppConfig.setup!({yaml: fn, env: 'development'})
      AppConfig
    end
  end

  describe "#AppConfig" do
    include_examples 'configuration library'
  end

end
