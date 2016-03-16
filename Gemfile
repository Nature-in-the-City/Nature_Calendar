source 'https://rubygems.org'

# Ruby version
ruby '2.2.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# CSS Framework
gem 'bootstrap-sass'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# meetup gems
gem 'omniauth'
gem 'omniauth-meetup'
gem 'httparty'
# integrate with Moment.js
gem 'momentjs-rails'
# authentication
gem 'devise'
# rich text editor
gem 'tinymce-rails'
# Template framework set to HAML
gem 'haml-rails'
gem 'rubocop', :require => false
gem 'paperclip'
gem 'rails-html-sanitizer'
gem 'remotipart'
# Task scheduler
gem 'rufus-scheduler'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '>=1.3.0'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'capybara', '2.4.4'
  gem 'capybara-webkit', '1.8.0' #i(rachel) did 'brew install qt' on mac [or 'apt-get install libqtwebkit-dev' on linux] to get this gem working for headless javascript tests in cucumber
  gem 'headless'
  gem 'rspec-rails', '~>3.2.1'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', require: nil
  gem 'fakeweb'
end

group :production do
  gem 'pg'
  gem 'puma'
  gem 'rails_12factor'
end


