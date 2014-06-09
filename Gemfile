source 'https://rubygems.org'

ruby "2.1.2"

gem 'railties', '4.1.1'
gem 'rails', '4.1.1'
gem 'rack-cors', :require => 'rack/cors'

# Authentication
gem 'devise', '~> 3.2.0'

# Model Decoration
gem 'draper', '~> 1.0'

gem 'sprig', '~> 0.1'

# Globals
gem 'ice_nine', '~> 0.11.0'

# Social
gem 'acts_as_commentable', '~> 4.0.0'
gem 'acts_as_votable', '~> 0.9.0'
# gem 'acts_as_votable', '~> 0.6.0'
gem 'acts_as_follower', '~> 0.2.1'
gem 'merit', '~> 2.1.1'

# Database
# gem 'activerecord-postgresql-extensions', :github => 'zoocasa/activerecord-postgresql-extensions', :branch => 'rails-4'
# gem 'activerecord-postgresql-cursors', '~> 0.1.0'
gem 'pg', '~> 0.17.0'
# gem 'activerecord-spatial', '~> 0.2.0'

# JSON
gem 'active_model_serializers', '~> 0.8.1'

# Pagination
gem 'will_paginate', '~> 3.0'

# Geo
gem 'geokit-rails', '~> 2.0.0'

# Files
gem 'carrierwave', '~> 0.9.0'
gem 'fog', '~> 1.3.1'

# New Relic
gem 'newrelic_rpm', '~> 3.6.6.147'

# Unstable gems - lock to known working version
gem 'memoist', '0.9.1'

group :development do
  gem 'spring'
  gem 'awesome_print'
  gem 'brice'
  gem 'hirb'
  gem 'pry'
  gem 'pry-rails'
  gem 'ruby_parser'
  gem 'term-ansicolor'
end

group :development, :test do
  gem 'simplecov', '~> 0.8.2'
end

gem 'capistrano', '2.12'

# Heroku
group :production do
  gem 'unicorn', '~> 4.6.3'
  gem 'rails_12factor', '~> 0.0.2'

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

group :profiling do
  gem 'active-profiling'
  gem 'ruby-prof'
end

group :guard do
  gem 'guard-minitest'
end

