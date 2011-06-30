# RubyX Standard Init Script for Rails 3

RailsVersion = "3.0.9"

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
- TellThemWhen.com Site API key

We are installing Rails #{RailsVersion} on Ruby #{RUBY_VERSION}

--------------------------------------------------
END
say(instructions)


############################################################
# Remove unnecessary Rails files and improve gitignore
#

# ReadME first development :)
run 'rm README'

file "README.md", <<-END
#{app_name.titleize}
===========================
END
git :init
git :add => "README.md"
git :commit => "-m 'Fix up the README'"

# Setup RVM RC and trust it
file ".rvmrc", <<-END
rvm ruby-#{RUBY_VERSION}@#{app_name.titleize} --create
END
run "rvm rvmrc trust"

# Change to the new RVM gemset
run "rvm ruby-#{RUBY_VERSION}@#{app_name.titleize} --create"

git :add => ".rvmrc -f"
git :commit => ".rvmrc -m 'Adding explicit RVMRC'"

# Improve the Gitignore
append_file ".gitignore", "\nconfig/database.yml"
append_file ".gitignore", "\n.rspec"
append_file ".gitignore", "\nvendor/bundle"
append_file ".gitignore", "\n.DS_Store"

git :add => ".gitignore"
git :commit => ".gitignore -m 'Ignore what we need to ignore'"

# Remove the other static files
run 'rm Gemfile'
run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm -f public/javascripts/*'

# Add the base system
git :add => "."
git :commit => "-a -m 'Initial commit of clean Rails #{RailsVersion} App'"

############################################################
# Setup Gemfile and RVM
#
file "Gemfile", <<-END
source :rubygems

gem "rails",                  "#{RailsVersion}"
gem "pg"
gem "sass"
gem "hoptoad_notifier"
gem "devise"
gem "simple_form"
gem "jquery-rails"
gem 'unicorn'
gem "app"

group :development, :test do
  gem "rspec-rails"
  gem 'capybara'
  gem 'database_cleaner'
  gem "launchy"
  gem "cucumber-rails"
  gem "autotest-rails"
  gem "shoulda"
  gem "machinist"
  gem "faker"
end
END

# Bundle install
run "gem install bundler"
run "bundle install"

git :add => "."
git :commit => "-a -m 'Gemset created and bundle installed'"


############################################################
# Database and create
#

# Remove default database file
run 'rm config/database.yml'

# Use the only real database with database swapping per branch
file "config/database.yml", <<-END
development: &DEVELOPMENT
  adapter: postgresql
  database: #{app_name}_development_<%= `git symbolic-ref HEAD 2>/dev/null`.chomp.sub('refs/heads/', '').gsub(/\W/,'_') %>
  encoding: unicode
  pool: 15
  username: postgres
  password:

test: &TEST
  adapter: postgresql
  database: #{app_name}_test_<%= `git symbolic-ref HEAD 2>/dev/null`.chomp.sub('refs/heads/', '').gsub(/\W/,'_') %>
  encoding: unicode
  pool: 15
  username: postgres
  password:

cucumber:
  <<: *TEST
END

environment "  config.time_zone = 'UTC'"

# Make a copy to check in
run 'cp config/database.yml config/database.example.yml'

# Create the DB
rake("db:create")

git :add => "."
git :commit => "-a -m 'Setup Database'"

############################################################
# Install App Config
#
generate "configurable"

git :add => "."
git :commit => "-a -m 'Setup App Configurable'"

############################################################
# Install JQuery
#
generate "jquery:install --ui"

git :add => "."
git :commit => "-a -m 'Installed JQuery'"

############################################################
# Install Reset CSS, SASS
#

# Download reset.css
get 'http://yui.yahooapis.com/2.8.1/build/reset/reset-min.css', 'public/stylesheets/reset.css'

# Create the SASS directory
run 'mkdir public/stylesheets/sass'
run 'touch public/stylesheets/sass/layout.scss'

# Override stylesheet_link_tag :defaults
environment "  config.action_view.stylesheet_expansions[:defaults] = ['reset', 'layout']"

# Sass config initializer
initializer('sass.rb') do
<<-END
# SASS config
Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = {}
Dir.glob("\#{Rails.root}/public/stylesheets/**/sass").each { |dir| Sass::Plugin.options[:template_location].merge!({dir => dir.to_s.split('/sass')[0]}) }
END
end

git :add => "."
git :commit => "-am 'Installed Sass configuration'"

# Clean up layout
run 'rm app/views/layouts/application.html.erb'

file "app/views/layouts/application.html.erb", <<-END
<!DOCTYPE html>
<html>
  <head>
    <title><%= @title || "#{app_name.titleize}" %></title>
    <%= stylesheet_link_tag :defaults %>
    <%= csrf_meta_tag %>
  <head>
  <body class="<%= controller.controller_name %>">
    <div id="Content">
      <%= yield %>
    </div>

    <%= yield :before_javascript %>
    <%= javascript_include_tag :defaults %>
    <%= yield :after_javascript %>
  </body>
<html>
END

git :add => "."
git :commit => "-am 'Updated application.html.erb, including javascripts and default styles'"


############################################################
# Remove test folder
#

git :rm => "-rf test"
git :commit => "-am 'Removing test folder'"


############################################################
# Generate RSpec and Cucumber
#

# Setup RSpec and Cucumber
generate "rspec:install"
generate "cucumber:install", "--rspec --capybara"

# Setup Machinist and Faker
run 'mkdir -p spec/support'
file 'spec/support/blueprints.rb', <<-END
require 'machinist/active_record'
require 'faker'
require 'sham'

Sham.email { Faker::Internet.email }
Sham.hostname { Faker::Internet.domain_name }
Sham.name  { Faker::Name.name }
Sham.text  { Faker::Lorem.sentence }

END

# doing { something }.should change(Something, :count).by(1)
file 'spec/support/custom.rb', <<-END
alias :doing :lambda
END

git :add => "."
git :commit => "-a -m 'Installed RSpec, Cucumber and Machinist'"



############################################################
# Setup base home controller and my/dashboard
#

# Setup home and dashboard
generate 'controller', 'home'
route("root :to => 'home#index'")

file 'app/views/home/index.html.erb', <<-END
<h1>Home</h1>
END

git :add => "."
git :commit => "-a -m 'Setup home controller and mapped root'"


############################################################
# Setup Additional Gems
#

# Setup Simple Form
generate "simple_form:install"
plugin 'country_select', :git => 'git://github.com/rails/country_select.git'

git :add => "."
git :commit => "-a -m 'Installed Simple Form'"

# Setup Devise
if ask("Setup Devise? (N/y)").upcase == 'Y'
  generate "devise:install"
  model_name = ask("What model name should devise use? (default: user)?")
  model_name = 'user' if model_name.blank?
  generate "devise", model_name
  generate 'devise:views'

  git :add => "."
  git :commit => "-a -m 'Setup devise'"
else
  say "=> Skipping Devise setup"
end

############################################################
# Setup Hoptoad and Google Analytics
#

# Setup HopToad
if ask("Setup Hoptoad? (N/y)").upcase == 'Y'
  hop_toad_key = ask("Please provide HopToad API Key:")
  generate "hoptoad", "--api-key #{hop_toad_key}"
  git :add => "."
  git :commit => "-a -m 'Installed HopToad'"
else
  say "=> Skipping HopToad setup"
end

# Setup Google Analytics
if ask("Do you have Google Analytics key? (N/y)").upcase == 'Y'
  ga_key = ask("Please provide your Google Analytics tracking key: (e.g UA-XXXXXX-XX)")
else
  ga_key = nil
end

file "app/views/shared/_google_analytics.html.erb", <<-CODE
<script type="text/javascript" charset="utf-8">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '#{ga_key || "INSERT-URCHIN-CODE"}']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
CODE

if ga_key
append_file "app/views/layouts/application.html.erb", <<-CODE
<%= render :partial => 'shared/google_analytics' %>
CODE
else
append_file "app/views/layouts/application.html.erb", <<-CODE
<%#= render :partial => 'shared/google_analytics' %>
CODE
end

git :add => "."
git :commit => "-am 'Added Google Analytics tracking code'"

# Setup TellThemWhen site support
if ask("Do you have a TellThemWhen Site Notification key? (N/y)").upcase == 'Y'
  tellthemwhenkey = ask("Please provide your TellThemWhen tracking key: (e.g 1a2b3c4d5e6f)")
else
  tellthemwhenkey = nil
end

file "app/views/shared/_tellthemwhen.html.erb", <<-CODE
<div id="TTWNotify" style="display:none;"></div>
<script type="text/javascript" charset="utf-8">
  (function(){
    t = document.createElement('script');t.async=true;t.type ='text/javascript';
    t.src = ('https:' == document.location.protocol ? 'https://secure.' : 'http://api.') + 'tellthemwhen.com/api/v2/notices/#{tellthemwhenkey || "INSERT-TELLTHEMWHE-KEY"}.js';
    var s=document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(t,s);
  })();
</script>
CODE

if tellthemwhenkey
append_file "app/views/layouts/application.html.erb", <<-CODE
<%= render :partial => 'shared/tellthemwhen' %>
CODE
else
append_file "app/views/layouts/application.html.erb", <<-CODE
<%#= render :partial => 'shared/tellthemwhen' %>
CODE
end

git :add => "."
git :commit => "-am 'Added TellThemWhen Site Notification code'"


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
