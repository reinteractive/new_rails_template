About
=====

This is the RubyX Rails 3 Template we use to kick off any new application.

Assumptions
---------------

This initialisation script assumes a few things:

* The latest version of Rails (currently 3.0.1)
* PostgreSQL for your database
* JQuery, Simple Form, HAML and SASS for views
* Devise for authentication
* Cucumber with Selenium and Capybara
* RSpec with Machinist and Faker
* Google analytics (optional)
* Hoptoad for issue tracking (optional)
* TellThemWhen for downtime notifications (optional)


Pre Initialisation Setup with RVM
---------------------------------

All RubyX app is developed using RVM and app specific Gemsets, so you need make sure you have bundler
installed in your global gemset, this saves installing it every single time:

    rvm gemset use 'global'
    gem install bundler

Once done, create a gemset for your app and use it:

    rvm gemset create 'appname'
    rvm gemset use 'appname'

Now we have a gemset, install rails:

    gem install rails --no-rdoc --no-ri

Usage
----------------------------------

To install a fresh rails app, do the following:

    rails new <appname> -m https://github.com/rubyx/rails3_template/raw/master/init.rb

While it is installing, go to Google, create a new account for the app and generate an urchin
code (UA-XXXXXX-XX) and make a note of this.  Also go to Hoptoad and create a project for this
app and get the Hoptoad API key (abcdef1234567890abcdef1234567890), you will be asked for
these as the script installs.

Process
---------------

1. Remove the stock README and replace with a Markdown README
2. Update the .gitignore file
3. Remove the stock Rails Gemfile and public static asset including prototype
4. Install a Gemfile with all gem requirements
5. Setup an .rvmrc for this app and trust it
6. Install all gems into the gemset
7. Replace database.yml with a PostgreSQL one
8. Copy this to database.example.yml
9. Set the app time zone to explicitly UTC
10. Create the database
11. Download JQuery latest from code.jquery.com
12. Download the latest Rails jQuery driver from github.com/rails/jquery-ujs
13. Setup a application.js with the jQuery document ready function
14. Change the defaults for javascript include tag help to include jQuery
15. Download the YUI reset css from yui.yahooapis.com
16. Create the SASS directory and initial ui layout file
17. Override the stylesheet defaults tag to include reset and the layout file
18. Create a HAML initializer to default HAML to HTML5
19. Create a SASS initializer and set to compressed style
20. Remove application.html.erb and replace with application.haml
21. Point application.haml at SASS, the javascripts etc
22. Install RSpec
23. Install Cucumber
24. Setup a base file for Machinist and Faker
25. Create a home controller and map root to it
27. Setup simple form
28. Install the country select plugin
29. Setup devise and ask for the devise model you want to use (defaults to user)
30. Ask if you want Hoptoad and setup with supplied urchin code
31. Ask if you want Google Analytics and setup with supplied urchin code
32. Ask if you want TellThemWhen support and setup with supplied code

After each major change it does a git commit as well to keep things tidy :)

Credits
=======

This is created from our work at RubyX, thanks also to Ivan Vanderbyl from Asterism for several patches.

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
