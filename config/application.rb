require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Turboapp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    config.generators do |g|
      g.test_framework nil
      g.helper false
      g.assets false
      g.fixture_replacement nil
    end
  end
end
