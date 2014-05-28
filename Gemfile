source 'https://rubygems.org'

gem 'rails', '4.1.0'

gem 'sass'
gem 'therubyracer', platforms: :ruby
gem 'haml'
gem 'uglifier', '>= 1.3.0'
gem 'ctl_base_ui', path: '../ctl-base-ui'
gem 'faraday', '0.8.9'
gem 'activeresource'
gem 'kramdown'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'teaspoon'
  gem 'phantomjs', '>= 1.8.1.1'
  gem 'dotenv-rails'
  gem 'jshintrb'
end

group :test do
  gem 'webmock'
  gem 'sinatra'
end

group :test do
  gem 'coveralls'
end
