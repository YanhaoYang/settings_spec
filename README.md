# SettingsSpec

[![Build Status](https://travis-ci.org/YanhaoYang/settings_spec.svg?branch=master)](https://travis-ci.org/YanhaoYang/settings_spec)

There are many tools to load configurations in Rails, such as
[rais\_config](https://github.com/railsconfig/rails_config),
[settingslogic](https://github.com/binarylogic/settingslogic).
Or you can just load your configurations in a YAML file directly,
`YAML.load_file("config.yml")`.

Normally, there will be a file named `config_sample.yml`, where
you write all configurations. When you deploy the application,
you make an copy of the sample file, change some values and launch
the application to see if it works or not.

And later, you add some new entries into the sample file as the
application grows. You must remember to add them to the configuration
file on production when you update the servers. Otherwise, the
application may refuse to work, complaining about missing configurations.

This gem is built to address the problem. It converts the sample
file into a specification file. Instead of giving some sample values,
you write rules to validate the configuration file, so that you know
the configuration file is all right before an invalid configuration
file breaks the application.

It is tested on Ruby 1.9.3, 2.1.2. It should also work on Ruby 1.8.7,
but you have to use `lambda` rather than `->`.

## Installation

Add this line to your application's Gemfile:

    gem 'settings_spec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install settings_spec

## Usage

It supports following rules in the specification file:

* `gt n`: the number should greater than n
* `lt n`: the number should less than n
* `match <regexp>`: match a string against a regexp
* `one_in <array_or_range>`: the value should be included in the given array\_or\_range
* `all_in <array_or_range>`: the value should be an array, which is a subset of the given array\_or\_range
* `is_a <class>`: the value should be a type of class
* `blank`: the value can be blank, meaning this entry is optional
* `call <proc>`: calls a proc to validate the value
* all above rules can be combined with `and`, `or`, and grouped with `()`

A specification file could look like this:

    defaults: &defaults
      api:
        url: match /^https/
        username: one_in %w{user1 user2}
        password: blank or match /\A.{8,}\z/
        retries: one_in 1..9
        enabled_env: all_in %w{staging production}
        reconnect: one_in [true false]
        pool: gt 3
      mod3: call ->(n){ n % 3 == 0}

    development:
      <<: *defaults

    test:
      <<: *defaults

It can validate any settings system which responds to `:<key>` or `:[]`.

Suppose the specification file is loaded this way:

    spec_file = Rails.root.join('config', 'config_spec.yml')
    specs = SettingsSpec.load(spec_file, Rails.env)

### Validate settingslogic

    class Settings < Settingslogic
      source Rails.root.join('config', 'config.yml')
      namespace 'development'
    end
    specs.verify!(Settings)

### Validate rails\_config

    RailsConfig.load_and_set_settings Rails.root.join('config', 'config.yml')
    specs.verify!(Settings)

### Validate app\_config

    AppConfig.setup!({yaml: Rails.root.join('config', 'config.yml'), env: Rails.env})
    specs.verify!(AppConfig)

### Validate YAML

    ::AppConfig = YAML.load_file(Rails.root.join('config', 'config.yml'))['development']
    specs.verify!(AppConfig)

## Contributing

1. Fork it ( https://github.com/YanhaoYang/settings\_spec/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
