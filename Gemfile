source 'https://rubygems.org'
ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5.x'
gem 'devise'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'simple-line-icons-rails'
gem 'trix'
gem 'kaminari', github: 'amatsuda/kaminari', branch: '0-17-stable'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'railroady'
  gem 'sqlite3'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg'
end
