source 'https://rubygems.org'

ruby "2.0.0"
gem 'railties', '4.0.1'
gem 'rails', '4.0.1'

# Authentication
gem 'devise', '~> 3.2.0'

# Social
gem 'acts_as_commentable', '~> 4.0.0'
gem 'acts_as_votable', '~> 0.6.0'
gem 'acts_as_follower', '~> 0.2.0'
gem 'simple_hashtag',
  :github => 'michaelhayman/simple_hashtag'

# Database
gem 'pg', '~> 0.17.0'

# JSON
gem 'active_model_serializers', '~> 0.8.1'

# Pagination
gem 'kaminari', '~> 0.14.1'

# Geo
gem 'geokit-rails', '~> 2.0.0'

# Testing

# Files
gem 'carrierwave', '~> 0.9.0'
gem 'fog', '~> 1.3.1'

# New Relic
gem 'newrelic_rpm', '~> 3.6.6.147'

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
  gem 'factory_girl_rails', '~> 4.2.0'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'faker', '~> 1.2.0'
end

