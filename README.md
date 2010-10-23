About
=====
This is the RubyX Rails 3 Template we use to kick off any new application.

Usage
---------------

You first need to create a gemset for your app and use it, as well as install rails 3

    rvm gemset create 'appname'

    rvm gemset use 'appname'

    gem install rails --no-rdoc --no-ri

Then install like so:

    rails new <appname> -m http://github.com/rubyx/rails3_template/raw/master/init.rb

You can install in an existing app if you wish:

    rake rails:template LOCATION=http://github.com/rubyx/rails3_template/raw/master/init.rb


Process
---------------

This script will attempt to:

Installs the following gems in the Gemfile for production:

* PostgreSQL
* JQuery
* HopToad
* Devise
* Simple Form
* HAML

Installs the following gems for development:

* autotest
* autotest-rails
* rspec
* rspec-rails
* cucumber
* database-cleaner
* cucumber-rails
* capybara
* capybara-envjs
* launchy
* selenium-webdriver
* shoulda
* machinist
* faker
* ruby-debug

Downloads and installs latest YUI reset.css

Creates ui.layout.scss for application styles

Downloads and installs the latest jQuery drivers, rails.js file for jQuery and removes all prototype helpers.

Set up the config/database.yml for this application.

Remove the README and create a README.md file.

Init a git repository and do a initial commits for each major step

Sets up Hoptoad using a supplied API key and does initial test.

Sets up Google Analytics using supplied GA Key

Creates application.haml layout containing Google Analytics tracking code, default javascripts included at the bottom, and reset styles.

Creates home and my/dashboard controller

Wires up root to Home

Removes all the prototype and stock rails files out of public

Sets up SASS and Haml to look in sub directories

Does a full bundle install

License
=======

(The MIT License)

Copyright (c) 2010

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
