# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'settings_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "settings_spec"
  spec.version       = SettingsSpec::VERSION
  spec.authors       = ["Yanhao Yang"]
  spec.email         = ["yanhao.yang@gmail.com"]
  spec.summary       = %q{Verifies the configurations against the specifications in a YAML file}
  spec.description   = %q{Verifies the configurations against the specifications in a YAML file}
  spec.homepage      = "https://github.com/YanhaoYang/settings_spec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "settingslogic", "~> 2.0"
  spec.add_development_dependency "activesupport", "~> 3.0" # for rails_config
  spec.add_development_dependency "rails_config", "~> 0.4"
  spec.add_development_dependency "app_config", "~> 2.5"
end
