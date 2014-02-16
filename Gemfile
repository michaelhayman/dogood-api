source 'https://rubygems.org'

ruby "2.1.0"

gem 'railties', '4.0.1'
gem 'rails', '4.0.1'
# gem 'zoocasa-rails-extensions', :git => 'git://git.i.internal/ruby/rails-extensions.git', :branch => 'rails-4'

# Authentication
gem 'devise', '~> 3.2.0'

# Model Decoration
gem 'draper', '~> 1.0'

# Social
gem 'acts_as_commentable', '~> 4.0.0'
gem 'acts_as_votable', '~> 0.6.0'
gem 'acts_as_follower', '~> 0.2.0'
gem 'simple_hashtag',
  :github => 'michaelhayman/simple_hashtag'

# Database
gem 'activerecord-postgresql-extensions', :github => 'zoocasa/activerecord-postgresql-extensions', :branch => 'rails-4'
gem 'activerecord-postgresql-cursors', '~> 0.1.0'
gem 'pg', '~> 0.17.0'
gem 'activerecord-spatial', '~> 0.2.0'

# JSON
gem 'active_model_serializers'
gem 'jbuilder', '~> 2.0'

# Pagination
gem 'kaminari', '~> 0.14.1'

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
  # debugging
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brice'
#  gem 'debugger'
#  gem 'debugger-ruby_core_source'
  gem 'hirb'
  gem 'pry'
  gem 'pry-rails'
  gem 'ruby_parser'
  gem 'term-ansicolor'

  # docs
  # deployment
end

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
  gem 'timecop'
end

group :profiling do
  gem 'active-profiling'
  gem 'ruby-prof'
end

group :guard do
  gem 'guard-jasmine'
  gem 'guard-minitest'
  gem 'guard-spin'
  gem 'zeus'
end

