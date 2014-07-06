require 'spec_helper'
require 'library_specs'
require 'settingslogic'

describe SettingsSpec do

  let(:settings) do
    ->(name) do
      Class.new(Settingslogic) do
        source File.dirname(__FILE__) + "/../fixtures/#{name}.yml"
        namespace 'development'
      end
    end
  end

  describe "#Settingslogic" do
    include_examples 'configuration library'
  end

end
