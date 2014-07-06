require 'spec_helper'

describe SettingsSpec::Specs do
  describe "#number" do

    it "8 can pass 'gt 5'" do
      specs = SettingsSpec::Specs.new({name: "gt 5"})
      specs.verify({name: 8})
      expect(specs.errors).to be_empty
    end

    it "2 cannot pass 'gt 5'" do
      specs = SettingsSpec::Specs.new({name: "gt 5"})
      specs.verify({name: 2})
      expect(specs.errors).to have_key("name")
    end

    it "3 can pass 'lt 5'" do
      specs = SettingsSpec::Specs.new({name: "lt 5"})
      specs.verify({name: 3})
      expect(specs.errors).to be_empty
    end

    it "6 cannot pass 'lt 5'" do
      specs = SettingsSpec::Specs.new({name: "lt 5"})
      specs.verify({name: 6})
      expect(specs.errors).to have_key("name")
    end

    it "can be in the array" do
      specs = SettingsSpec::Specs.new({name: "one_in [1, 2, 3]"})
      specs.verify({name: 3})
      expect(specs.errors).to be_empty
    end

    it "can be in the range" do
      specs = SettingsSpec::Specs.new({name: "one_in 1..3"})
      specs.verify({name: 3})
      expect(specs.errors).to be_empty
    end

    it "returns an error when the number is not in the array" do
      specs = SettingsSpec::Specs.new({name: "one_in [1, 2, 3]"})
      specs.verify({name: 4})
      expect(specs.errors).to have_key("name")
    end

    it "combines specs with 'or' and 'and'" do
      specs = SettingsSpec::Specs.new({name: "blank or (gt 3 and lt 8)"})
      specs.verify({name: nil})
      expect(specs.errors).to be_empty
      specs.verify({name: 5})
      expect(specs.errors).to be_empty
      specs.verify({name: 9})
      expect(specs.errors).to have_key("name")
    end
  end

  describe "#string" do

    it "returns no error when the setting matches the regexp" do
      specs = SettingsSpec::Specs.new({name: "match /^a/"})
      specs.verify({name: "abc"})
      expect(specs.errors).to be_empty
    end

    it "returns an error when the setting does not match the regexp" do
      specs = SettingsSpec::Specs.new({name: "match /^a/"})
      specs.verify({name: "bcd"})
      expect(specs.errors).to have_key("name")
    end

    it "can be in the array" do
      specs = SettingsSpec::Specs.new({name: "one_in %w{a b c}"})
      specs.verify({name: 'b'})
      expect(specs.errors).to be_empty
    end

    it "returns an error when the number is not in the array" do
      specs = SettingsSpec::Specs.new({name: "one_in %w{a b c}"})
      specs.verify({name: 'd'})
      expect(specs.errors).to have_key("name")
    end

    it "combines specs with 'or' and 'and'" do
      specs = SettingsSpec::Specs.new({name: 'blank or one_in %w{a b c} or match /^\d{2}/'})
      specs.verify({name: nil})
      expect(specs.errors).to be_empty
      specs.verify({name: 'a'})
      expect(specs.errors).to be_empty
      specs.verify({name: '99a'})
      expect(specs.errors).to be_empty
      specs.verify({name: '9a'})
      expect(specs.errors).to have_key("name")
    end
  end

  describe "#array" do
    it "can include any items from the array" do
      specs = SettingsSpec::Specs.new({name: "all_in %w{a b c}"})
      specs.verify({name: %w{a b}})
      expect(specs.errors).to be_empty
    end

    it "returns an error when one or several items are not in the array" do
      specs = SettingsSpec::Specs.new({name: "all_in %w{a b c}"})
      specs.verify({name: %w{c d}})
      expect(specs.errors).to have_key("name")
    end
  end

  it "nil can pass 'blank'" do
    specs = SettingsSpec::Specs.new({name: "blank"})
    specs.verify({name: nil})
    expect(specs.errors).to be_empty
  end

  it "empty string can pass 'blank'" do
    specs = SettingsSpec::Specs.new({name: "blank"})
    specs.verify({name: ''})
    expect(specs.errors).to be_empty
  end

  it "calls a proc" do
    specs = SettingsSpec::Specs.new({name: 'call ->(v){ v % 3 == 0 }'})
    specs.verify({name: 3})
    expect(specs.errors).to be_empty
    specs.verify({name: 4})
    expect(specs.errors).to have_key("name")
  end

  it "raise an exception when 'verify!' fails" do
    msg = %{Some settings do not pass verification:\n  name: "match /^a/ [val: ]"}
    specs = SettingsSpec::Specs.new({name: 'match /^a/'})
    expect { specs.verify!({name: ''}) }.to raise_error(StandardError, msg)
  end

  it "cannot be nil" do
    specs = SettingsSpec::Specs.new({name: "blank"})
    specs.verify(nil)
    expect(specs.errors).to have_key(".")
  end

  it "can check the type of the value" do
    specs = SettingsSpec::Specs.new({name: "is_a String"})
    specs.verify(name: 'str')
    expect(specs.errors).to be_empty
  end

  it "fails when the type mismatches" do
    specs = SettingsSpec::Specs.new({name: "is_a String"})
    specs.verify(name: 3)
    expect(specs.errors).to have_key("name")
  end

  it "is optional if all its children are optional" do
    specs = SettingsSpec::Specs.new({l1: {l2: {l2a: "blank", l2b: "blank"}}})
    specs.verify({})
    expect(specs.errors).to be_empty
    specs.verify({l1: nil})
    expect(specs.errors).to be_empty
  end

  it "handles `false` correctly" do
    specs = SettingsSpec::Specs.new({name: "one_in [true, false]"})
    specs.verify("name" => false)
    expect(specs.errors).to be_empty
  end

end

