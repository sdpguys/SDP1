# config/application.rb

require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load dotenv only in development and test environments,
# so you don't accidentally load .env in production.
if Rails.env.development? || Rails.env.test?
  require "dotenv"
  Dotenv::Railtie.load
end

module Sdp1Demo
  class Application < Rails::Application
    config.load_defaults 8.0

    # If you want to log the key at startup (for debugging only):
    config.after_initialize do
      Rails.logger.info "ENV['OPENAI_API_KEY']: #{ENV['OPENAI_API_KEY']}"
    end

    # Configuration for the application, engines, and railties goes here.
  end
end
