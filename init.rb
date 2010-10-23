# RubyX Standard Init Script for Rails 3

instructions =<<-END

Running the RubyX Standard Init Script for Rails 3
--------------------------------------------------

During installation you will be asked for a number
of credentials for different services, these are 
entirely optional however you might like to gather 
these now.

- Hoptoad API key
- Google Analytics tracking code e.g UA-XXXXXX-XX
  This can be found on your Google Analytics settings page.

--------------------------------------------------
END
say(instructions)

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
#{app_name.titleize}
==
END

run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm -f public/javascripts/*'

# Download reset.css
get 'http://yui.yahooapis.com/2.8.1/build/reset/reset-min.css', 'public/stylesheets/reset.css'

# Create the SASS directory
run 'mkdir public/stylesheets/sass'
run 'touch public/stylesheets/sass/ui.layout.scss'

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
append_file ".gitignore", "vendor/bundle"

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
model_name = ask("What model name should devise use? (e.g. User)?")
model_name = 'user' if model_name.blank?
generate "devise", model_name
generate 'devise:views'

git :add => "."
git :commit => "-a -m 'Setup devise'"

# Setup HopToad
if ask("Setup Hoptoad? (N/y)").upcase == 'Y'
  hop_toad_key = ask("Please provide HopToad API Key:")
  generate "hoptoad", "--api-key #{hop_toad_key}"
else
  say "=> Skipping HopToad setup"
end

git :add => "."
git :commit => "-a -m 'Installed HopToad'"

# HAML & Sass config
file "config/initializers/haml_sass.rb", <<-LOL
# HAML and Sass config

# Compress output CSS
Sass::Plugin.options[:style] = :compressed

# Use HTML5 by default
Haml::Template.options[:format] = :html5

# Look in sub folders for Sass files
Sass::Plugin.options[:template_location] = {}
Dir.glob("\#\{Rails.root\}/public/stylesheets/**/sass").each { |dir| Sass::Plugin.options[:template_location].merge!({dir => dir.to_s.split('/sass')[0]}) }
LOL

git :add => "."
git :commit => "-am 'Installed HAML and Sass configuration'"

run 'rm app/views/layouts/application.html.erb'

file "app/views/layouts/application.haml", <<-LOL
!!!
%html
  %head
    %title= @title || "#{app_name.titleize}"
    = stylesheet_link_tag 'reset', 'ui.layout'
    = csrf_meta_tag
  %body
    = yield
    
    = javascript_include_tag :defaults
    = yield :bottom_javascript
LOL

git :add => "."
git :commit => "-am 'Replaced application layout with Haml, including javascripts and default styles'"

if ask("Add Google Analytics tracking to layout? (N/y)").upcase == 'Y'
  ga_key = ask("Please provide your Google Analytics tracking key: (e.g UA-XXXXXX-XX)")
file "app/views/shared/_google_analytics.haml", <<-LOL
:javascript
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '#{ga_key}']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
LOL

append_file "app/views/layouts/application.haml", <<-LOL
    = render :partial => 'shared/google_analytics'
LOL
  git :add => "."
  git :commit => "-am 'Added Google Analytics tracking code'"
else
  say "=> Skipping Google Analytics setup"
end


instructions =<<-END

Rails Template Install Complete
--------------------------------

All complete, please configure:

  initializers/devise.rb
  initializers/simple_form.rb

Also setup actionmailer in your production and development environments.

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }  # dev + test
  config.action_mailer.default_url_options = { :host => '#{app_name}.com' } # production

Then edit the db/migrate/TIMESTAMP_create_#{model_name}.rb file to suit and run

  rake db:migrate

END
say(instructions)