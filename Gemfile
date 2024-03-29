source 'https://rubygems.org'
ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
gem 'pg'
gem 'rails_12factor', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Nested comments
gem 'closure_tree'

# Markdown
gem 'redcarpet'

# Amazon S3
gem 'aws-sdk'

# Vote system
gem 'thumbs_up', github: 'bouchard/thumbs_up'

# Originated from Polls (issue-40)
gem 'render_anywhere', :require => false

# Data migration
gem 'migration_data'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
gem 'puma'

# Combat spam 😾
gem 'invisible_captcha'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

source 'https://rails-assets.org' do
  # autosizes textareas for better writing experience
  gem 'rails-assets-autosize'
  gem 'rails-assets-fastclick'
end

# Paginator
gem 'kaminari'

# URL validator cuz URI.regexp sucks
# gem 'valid_url'

# Admin tools convos.org/admin
gem 'rails_admin'

# Lightweight meta tags for SEO (for more features check out MetaTags)
gem 'metamagic'

# generate slugs
gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+

# monitoring
gem 'newrelic_rpm'
