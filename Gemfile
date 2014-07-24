source 'https://rubygems.org'
#ruby-gemset=mira

gem 'rails', '4.0.5'
gem 'sqlite3'

gem 'hydra', '6.2.0'
gem 'hydra-role-management', '0.1.0'
gem 'hydra-editor', '0.1.0'
gem 'hydra-batch-edit', '1.1.1'
gem 'qa', '0.0.3'
gem 'sanitize', '2.0.6'

gem 'solrizer'
gem 'disable_assets_logger', :group => :development
gem 'devise_ldap_authenticatable', '0.8.1'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem "bootstrap-sass"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem "jquery-fileupload-rails"

gem "devise"
gem 'bootstrap_forms'
gem 'rmagick', '2.13.2', require: 'RMagick'
gem 'resque-status'
gem 'carrierwave', '~> 0.10.0'

gem 'blacklight_advanced_search', '~> 2.2'

group :development do
  gem 'unicorn'
  gem 'jettywrapper'
end

group :tdldev,:production do
  gem 'mysql2'
  gem 'activerecord-mysql-adapter'
end


group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'byebug', require: false
  gem 'ladle'
end

gem 'chronic' # for lib/tufts/model_methods.rb
gem 'titleize' # for lib/tufts/model_methods.rb
gem 'settingslogic' # for settings
