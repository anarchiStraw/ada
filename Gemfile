source 'http://rubygems.org'

gem 'rails', '3.1.1'
gem 'rake', '0.8.7'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'configatron', :require => 'configatron'
gem 'pit', :require => "pit"
gem 'hoptoad_notifier'
gem "oauth"
gem "oauth-plugin"
gem 'haml'
gem 'nokogiri'
group :production do
  gem "pg"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'


group :test do
  # To use debugger
  gem 'ruby-debug19', :require => 'ruby-debug'

  # Pretty printed test output
  gem 'turn', :require => false
end
