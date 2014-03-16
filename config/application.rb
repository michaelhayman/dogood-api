require File.expand_path('../boot', __FILE__)

require 'rails/all'

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

    config.middleware.delete "ActionDispatch::Cookies"
    config.middleware.delete "ActionDispatch::Session::CookieStore"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"

    config.secret_token = "20382038salkjfoiusdfuanklajsdfouoausjdfjlaksjdlfjajsjdfkjslakjdfjjfklajsdfj"

    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end
  end
end
