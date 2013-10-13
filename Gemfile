source 'https://rubygems.org'

ruby "2.0.0"
gem 'rails', '4.0.0'

# Authentication
gem 'devise', '~> 3.0.2'
gem 'twitter'
gem 'fb_graph'

# Social
gem 'acts_as_commentable'
gem 'acts_as_votable', '~> 0.6.0'
gem 'acts_as_follower'
gem 'simple_hashtag', :git => "git@github.com:/michaelhayman/simple_hashtag.git"

# Database
gem 'pg'

# Images
gem 'rmagick'



# JSON
gem 'active_model_serializers'

# Testing
# gem "bullet", :group => "development"

# Files
gem 'carrierwave'
gem 'fog', '~> 1.3.1'

# New Relic
gem 'newrelic_rpm'

# Heroku
group :production do
  gem 'unicorn'
  gem 'rails_12factor', group: :production

  # Caching
  gem 'rack-cache'
  gem 'dalli'
  gem 'kgio'
end

