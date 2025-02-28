require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

# Load environment variables using dotenv in development and test environments.
if Rails.env.development? || Rails.env.test?
  require "dotenv/load"
end

require "zeitwerk"


module Sdp1Demo
  class Application < Rails::Application
    config.load_defaults 8.0

    config.after_initialize do
      Rails.logger.info "ENV['OPENAI_API_KEY']: #{ENV['OPENAI_API_KEY']}"
    end
  end
end
