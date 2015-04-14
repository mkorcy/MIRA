source 'https://rubygems.org'
#ruby-gemset=mira

gem 'rails', '4.1.6'

gem 'mysql2'

gem 'hydra-head', '~> 7.2.1'
gem 'blacklight', '~> 5.7.1'
gem 'active-fedora', '~> 7.1.1'
gem 'hydra-editor', '~> 0.5.0'
gem 'hydra-role-management', '0.2.0'
gem 'hydra-batch-edit', '1.1.1'
gem 'qa', '0.3.0'

gem 'sanitize', '2.0.6'

gem 'solrizer'
gem 'disable_assets_logger', :group => :development
gem 'devise_ldap_authenticatable', '0.8.1'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem "bootstrap-sass"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby
gem 'resque-pool'

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem "jquery-fileupload-rails"

gem "devise"
gem 'bootstrap_form'
gem 'rmagick', '2.13.2', require: 'RMagick'
gem 'resque-status'
gem 'carrierwave', '~> 0.10.0'

gem 'blacklight_advanced_search'
gem 'tufts_models', github: 'curationexperts/tufts_models', ref: 'fe20b493536edf2a8dfbcedae9df110351aa6a97'

group :development do
  gem 'jettywrapper'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
end

group :tdldev,:production do
  gem 'mysql2'
  gem 'activerecord-mysql-adapter'
end


group :development, :test do
  gem 'rspec-rails', '~> 2.99'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'sqlite3'
end

group :debug do
  gem 'unicorn'
  gem 'launchy'
  gem 'byebug', require: false
  gem 'ladle'
end

gem 'chronic' # for lib/tufts/model_methods.rb
gem 'titleize' # for lib/tufts/model_methods.rb
gem 'settingslogic' # for settings
