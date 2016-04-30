source 'https://rubygems.org'

# Ruby version
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# CSS Framework
gem 'bootstrap-sass'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc
# meetup gems
gem 'omniauth'
gem 'omniauth-meetup'
gem 'httparty'
gem 'rMeetup'
# google gems
gem 'google-api-client'
# integrate with Moment.js
gem 'momentjs-rails'
# authentication
gem 'devise'
# rich text editor
gem 'tinymce-rails'
# Template framework set to HAML
gem 'haml-rails'
# codeclimate style checking
gem 'rubocop', require: false
gem 'paperclip'
gem 'rails-html-sanitizer'
gem 'remotipart'
# Task scheduler
gem 'rufus-scheduler'
# Font Awesome Icons
gem 'font-awesome-sass'
# Puma Worker Killer
gem 'puma_worker_killer'
# text editor
gem 'tinymce-rails'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'capybara-webkit' #i(rachel) did 'brew install qt' on mac [or 'apt-get install libqtwebkit-dev' on linux] to get this gem working for headless javascript tests in cucumber
  gem 'headless'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', require: nil
  gem 'fakeweb'
  gem 'railroady' # class diagrams
  gem "factory_girl_rails", "~> 4.0" # FactoryGirl
end

group :production do
  gem 'pg'
  gem 'puma'
  gem 'rails_12factor'
end
