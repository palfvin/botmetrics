source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails'
gem 'protected_attributes'
gem 'rake'
gem 'nokogiri'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg'
gem 'childprocess'
gem 'highcharts-rails'
gem 'omniauth-facebook'
gem 'google_drive'
gem 'newrelic_rpm'
gem 'thin'
gem 'coffee-script'
gem 'therubyracer', :require => 'v8'
gem 'underscore-rails'
gem 'date_easter'

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'spork-rails', :git => 'https://github.com/sporkrb/spork-rails'
  gem 'shoulda-matchers'
  gem 'spork'
  gem 'launchy'
  gem 'annotate'
  gem 'quiet_assets'
  gem 'jasminerice', :git => 'https://github.com/bradphelan/jasminerice.git'
  gem 'guard-jasmine'
end

# Gems used only for assets and not required
# in production environments by default.

group :test do
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'rb-fsevent', :require => false
  gem 'growl'
  gem 'growl_notify'
end

group :production do
  gem  'rails_12factor'
end