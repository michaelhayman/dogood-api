require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module DoGoodApp
  class Application < Rails::Application
   require "#{Rails.root}/config/additional_requires"
   # require "#{Rails.root}/config/site_settings"

   require "#{Rails.root}/lib/do_good/api/error"
    %w{
      lib
    }.each do |dir|
      config.autoload_paths << "#{Rails.root}/#{dir}"
    end

    # config.autoload_paths << File.join(Rails.root, "app", "classes")
    # p File.join(Rails.root, "app", "serializers")
    # config.autoload_paths << File.join(Rails.root, "app", "serializers")
    # config.autoload_paths << "#{Rails.root}/app/serializers"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #
    # Disable certain things for API-only apps
    # config.assets.enabled = false
    # config.assets.initialize_on_precompile = false
    config.middleware.delete "ActionDispatch::Cookies"
    config.middleware.delete "ActionDispatch::Session::CookieStore"
    config.middleware.delete "ActionDispatch::Flash"

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"

    # config.middleware.delete "ActionDispatch::Static"
    # config.middleware.delete "Rack::MethodOverride"
    # config.middleware.delete "Rails::Rack::Logger"
    # config.middleware.delete "ActionDispatch::DebugExceptions"
    # config.middleware.delete "ActionDispatch::RequestId"
    # config.middleware.delete "ActionDispatch::RemoteIp"
    # config.middleware.delete "ActionDispatch::Reloader"
    #

    # We need a secret token for session, cookies, etc.
    config.secret_token = "20382038salkjfoiusdfuanklajsdfouoausjdfjlaksjdlfjajsjdfkjslakjdfjjfklajsdfj"

    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }

    config.middleware.use Rack::Cors do
      allow do
        origins 'localhost'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end
  end
end
