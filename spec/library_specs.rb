shared_examples "configuration library" do
  spec_file = File.expand_path(File.dirname(__FILE__) + "/fixtures/settings_spec.yml")
  let(:specs) { SettingsSpec.load(spec_file, 'development') }

  it 'valid settings 1 should pass' do
    specs.verify(settings.call('valid-settings-1'))
    expect(specs.errors).to be_empty
  end

  it 'valid settings 2 should pass' do
    specs.verify(settings.call('valid-settings-2'))
    expect(specs.errors).to be_empty
  end

  it 'invalid settings 1 should fail' do
    specs.verify(settings.call('invalid-settings-1'))
    error_keys = [
      "l1a",
      "l1b:l2a",
      "l1b:l2b",
      "l1b:l2c",
      "l1c:l2e",
      "l1c:l2f",
      "l1c:l2g",
      "l1d",
    ]
    expect(specs.errors.keys.sort).to eq(error_keys)
  end

  it 'invalid settings 2 should fail' do
    specs.verify(settings.call('invalid-settings-2'))
    error_keys = ["l1a", "l1b:l2a", "l1b:l2b", "l1b:l2c", "l1d"]
    expect(specs.errors.keys.sort).to eq(error_keys)
  end
end
