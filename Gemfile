source 'https://rubygems.org'

ruby "2.1.5"

gem 'rails', '4.2'
gem 'rack-cors', :require => 'rack/cors'

gem 'rails_autolink'

gem 'sass-rails'

gem 'uglifier'

# Configuration
gem 'figaro', '~> 0.7.0'

# Authentication
gem 'devise', '~> 3.4'

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
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-8-stable'

# Pagination
gem 'will_paginate', '~> 3.0'

# Geo
gem 'geokit-rails', github: 'geokit/geokit-rails'

# Files
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick'

gem 'fog', '~> 1.26'

gem 'friendly_id'

gem 'slim'

# New Relic
gem 'newrelic_rpm', '~> 3.6.6.147'

# Unstable gems - lock to known working version
gem 'memoist', '0.11.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-fastclick', '~> 1.0.6'
  gem 'rails-assets-typeahead.js', '~> 0.10.5'
  gem 'rails-assets-magnific-popup', '~> 1.0.0'
  gem 'rails-assets-jquery-ujs', '~> 1.0.3'
end

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
  gem 'mechanize'
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
