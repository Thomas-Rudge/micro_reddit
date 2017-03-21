source 'https://rubygems.org'
ruby '2.3.0'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test]

gem 'rails',        '~> 5.0.1'
gem 'puma',         '~> 3.0'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder',   '~> 2.5'
gem 'bcrypt',     '~> 3.1.11'
gem 'humanizer',  '~> 2.6.3'
gem 'will_paginate', '3.1.0'
gem "recaptcha", require: "recaptcha/rails"
# These are here because seed data will be produced in Prod
gem 'factory_girl_rails', '~> 4.5.0'
gem 'faker', branch: 'master' , git: 'https://github.com/stympy/faker.git'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platform: :mri
  gem 'rspec-rails',        '~> 3.5'
  gem 'rails-controller-testing'
  gem 'capybara',           '~> 2.5'
end

group :development do
  gem 'web-console',           '>= 3.3.0'
  gem 'listen',                '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'guard'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'database_cleaner', '~> 1.5'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
