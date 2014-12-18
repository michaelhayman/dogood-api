source 'https://rubygems.org'

ruby "2.1.5"

gem 'railties', '4.1.8'
gem 'rails', '4.1.8'
gem 'rack-cors', :require => 'rack/cors'

gem 'rails_autolink'

gem 'sass-rails'

gem 'bower-rails'

gem 'uglifier'

# Configuration
gem 'figaro', '~> 0.7.0'

# Authentication
gem 'devise', '~> 3.2.0'

# Notifications
gem 'houston', '~> 2.1'

# Jobs
gem 'sidekiq', '~> 3.1'

# Model Decoration
gem 'draper', '~> 1.0'

gem 'sprig', '~> 0.1'

# Globals
gem 'ice_nine', '~> 0.11.0'

# Social
gem 'acts_as_commentable', '~> 4.0.0'
gem 'acts_as_votable', '~> 0.9.0'
gem 'acts_as_follower', '~> 0.2.1'
gem 'merit', '~> 2.1.1'

# Database
gem 'pg', '~> 0.17.0'

# JSON
gem 'active_model_serializers', '~> 0.8.1'

# Pagination
gem 'will_paginate', '~> 3.0'

# Geo
gem 'geokit-rails', '~> 2.0.0'

# Files
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick'

gem 'fog', '~> 1.3.1'

gem 'friendly_id'

gem 'rails-assets-fastclick'

gem 'slim'

# New Relic
gem 'newrelic_rpm', '~> 3.6.6.147'

# Unstable gems - lock to known working version
gem 'memoist', '0.9.1'

group :development do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-sidekiq' , github: 'seuros/capistrano-sidekiq'
  gem 'spring'
  gem 'awesome_print'
  gem 'brice'
  gem 'hirb'
  gem 'pry'
  gem 'pry-rails'
  gem 'ruby_parser'
  gem 'term-ansicolor'
  gem 'guard-minitest'
end

group :development, :test do
  gem 'simplecov', '~> 0.8.2'
end

# Heroku
group :production do
  gem 'unicorn', '~> 4.6.3'
  # gem 'rails_12factor', '~> 0.0.2'
  gem 'rb-readline', '~> 0.5.1'

  # Caching
  gem 'rack-cache', '~> 1.2'
  gem 'dalli', '~> 2.6.4'
  gem 'memcachier', '~> 0.0.2'
  gem 'kgio', '~> 2.6'
end

group :test do
  gem 'factory_girl_rails'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rr'
  gem 'faker'
end
