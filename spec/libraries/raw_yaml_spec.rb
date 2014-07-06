require 'spec_helper'
require 'library_specs'

describe SettingsSpec do

  let(:settings) do
    ->(name) do
      fn = File.dirname(__FILE__) + "/../fixtures/#{name}.yml"
      YAML.load_file(fn)['development']
    end
  end

  describe "#YAML" do
    include_examples 'configuration library'
  end

end
