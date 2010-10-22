# RubyX Standard Init Script for Rails 3

run 'rm Gemfile'

file "Gemfile", <<-END
source :rubygems

gem "rails",                  "3.0.1"
gem "pg",                     "~> 0.9.0"
gem "haml",                   "~> 3.0.22"
gem "hoptoad_notifier",       "~> 2.3.8"
gem "devise",                 "~> 1.1.3"
gem "simple_form",            "~> 1.2.2"
gem "paperclip",              "~> 2.3.4"
gem "aws-s3",                 "~> 0.6.2", :require => 'aws/s3'
    
group :test do
  gem 'capybara',             "~> 0.3.9"
  gem "capybara-envjs",       "~> 0.1.6"
  gem 'database_cleaner',     "~> 0.5.2"
  gem "cucumber-rails",       "~> 0.3.2"
  gem "rspec-rails",          "~> 2.0.0"
  gem "launchy",              "~> 0.3.7"
  gem "selenium-webdriver",   "~> 0.0.29"
  gem "autotest-rails",       "~> 4.1.0"
  gem "shoulda",              "~> 2.11.3"
  gem "machinist",            "~> 1.0.6"
  gem "faker",                "~> 0.3.1"
  gem "ruby-debug"
end
END

# Remove unnecessary Rails files
run 'rm README'

file "README.md", <<-END
Readme for #{app_name}
END

run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm -f public/javascripts/*'

# Create the SASS directory
run 'mkdir public/stylesheets/sass'
run 'touch public/stylesheets/sass/main.scss'

# Downloading latest jQuery.min
get "http://code.jquery.com/jquery-latest.min.js", "public/javascripts/jquery.js"

# Downloading latest jQuery drivers
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

# Create a base application.js
file "public/javascripts/application.js", <<-END
jQuery(function ($) {
  /**
   * App code in here
   */
};
END

environment "  config.action_view.javascript_expansions[:defaults] = %w(jquery rails)"
environment "  config.time_zone = 'UTC'"

# Clean up the git ignore
append_file ".gitignore", "config/database.yml"
append_file ".gitignore", "config/.rvmrc"
append_file ".gitignore", ".rspec"

# Remove default database file
run 'rm config/database.yml'

# Use the only real database :)
file "config/database.yml", <<-END
development: &DEVELOPMENT
  adapter: postgresql
  database: #{app_name}_development
  encoding: unicode
  pool: 15
  username: postgres
  password:

test: &TEST
  adapter: postgresql
  database: #{app_name}_test
  encoding: unicode
  pool: 15
  username: postgres
  password:

cucumber:
  <<: *TEST
END

# Setup RVM RC
file ".rvmrc", <<-END
rvm ruby-1.8.7@#{app_name}
END

# Use Gemset
run "rvm rvmrc trust"

# Bundle install
run "gem install bundler"
run "bundle install"

run "bundle show"

# Make a copy to check in
run 'cp config/database.yml config/database.example.yml'

# Create the DB
rake("db:create")

git :init
git :add => "."
git :commit => "-a -m 'Initial commit of base system'"


# Setup RSpec and Cucumber
generate "rspec:install"
generate "cucumber:install", "--rspec --capybara"

git :add => "."
git :commit => "-a -m 'Installed RSpec and Cucumber'"

# Setup home and dashboard
generate 'controller', 'home'
generate 'controller', 'my/dashboard'
route("root :to => 'home#index'")

git :add => "."
git :commit => "-a -m 'Setup home and dashboard controllers'"

# Setup Simple Form
generate "simple_form:install"
plugin 'country_select', :git => 'git://github.com/rails/country_select.git'

git :add => "."
git :commit => "-a -m 'Installed Simple Form'"

# Setup Devise
generate "devise:install"
model_name = ask("What model name should devise use? (e.g. user)?")
model_name = 'user' if model_name.blank?
generate "devise", model_name
generate 'devise:views'

git :add => "."
git :commit => "-a -m 'Setup devise'"

# Setup HopToad
if ask("Setup Hoptoad?")
  hop_toad_key = ask("Please provide HopToad API Key:")
  generate "hoptoad", "--api-key #{hop_toad_key}"
end

git :add => "."
git :commit => "-a -m 'Installed HopToad'"

file "script/sass-watch.sh", <<-END
#!/bin/sh
bundle exec sass --watch public/stylesheets/sass/:public/stylesheets/
END
run 'chmod 755 script/sass-watch.sh'

git :add => "."
git :commit => "-a -m 'Installed sass-watch script'"

instructions =<<-END

Rails Template Install Complete
--------------------------------

All complete, please configure:

  initializers/devise.rb
  initializers/simple_form.rb

Also setup actionmailer in your production and development environments.

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }  # dev + test
  config.action_mailer.default_url_options = { :host => '#{app_name}.com' } # production

To run the sass watcher, simply run:

  ./script/sass-watch.sh

Then edit the db/migrate/TIMESTAMP_create_#{model_name}.rb file to suit and run

  rake db:migrate

END
say(instructions)