require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module DoGoodApp
  class Application < Rails::Application
    require "#{Rails.root}/config/additional_requires"

    require "#{Rails.root}/lib/ruby-core-extensions.rb"

    require "#{Rails.root}/lib/do_good/api/error"

    %w{
      lib
    }.each do |dir|
      config.autoload_paths << "#{Rails.root}/#{dir}"
    end

    config.assets.paths << Rails.root.join("vendor", "assets", "bower_components")

    config.i18n.enforce_available_locales = false

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"

    config.secret_token = "20382038salkjfoiusdfuanklajsdfouoausjdfjlaksjdlfjajsjdfkjslakjdfjjfklajsdfj"

    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }

    config.exceptions_app = self.routes

    config.active_record.raise_in_transactional_callbacks = true

    config.active_support.test_order = :random

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end
  end
end
