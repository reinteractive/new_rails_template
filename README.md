About
=====

This is the reinteractive Rails 5 Template we use to kick off any new application.

Assumptions
---------------

This initialisation script assumes a few things:

* Ruby 2.3.1
* The latest version of Rails (currently 5.0.1)
* PostgreSQL for your database
* JQuery, Simple Form, HTML for views and SASS for stylesheets
* Devise for authentication
* RSpec with FactoryGirl and Faker
* Google analytics (optional)


Pre Initialisation Setup with RVM
---------------------------------

If you are using RVM, doing the following should get you ready to use this script.

    rvm install ruby-2.3.1
    rvm gemset create <appname>
    rvm gemset use <appname>
    gem install bundler

Now we have a gemset, install rails:

    gem install rails -v 5.0.1 --no-rdoc --no-ri

Usage
----------------------------------

To install a fresh rails app, do the following:

    rails new <appname> -m https://github.com/reinteractive/new_rails_template/raw/rails-5-0-1/init.rb

While it is installing, go to Google, create a new account for the app and generate an urchin
code (UA-XXXXXX-XX) and make a note of this.  Also get a project code for this app for Bugsnag
and get the API key.

Process
---------------

1. Remove the stock README and replace with a Markdown README
2. Update the .gitignore file
3. Remove the stock Rails Gemfile and public static asset including prototype
4. Install a Gemfile with all gem requirements
5. Setup an .ruby-version for this app
6. Setup an .ruby-gemset for this app
7. Install all gems into the gemset
8. Replace database.yml with a PostgreSQL one
9. Copy this to database.example.yml
10. Set the app time zone to explicitly UTC
11. Create the database
12. Download JQuery latest from code.jquery.com
13. Download the latest Rails jQuery driver from github.com/rails/jquery-ujs
14. Setup a application.js with the jQuery document ready function
15. Change the defaults for javascript include tag help to include jQuery
16. Download the YUI reset css from yui.yahooapis.com
17. Create the SASS directory and initial ui layout file
18. Override the stylesheet defaults tag to include reset and the layout file
19. Create a SASS initializer and set to compressed style
20. Update application.html.erb with the basics
21. Install RSpec
22. Setup a base file for FactoryGirl and Faker
23. Create a home controller and map root to it
24. Setup simple form
25. Install the country select plugin
26. Setup devise and ask for the devise model you want to use (defaults to user)
27. Ask if you want Bugsnag and setup with supplied urchin code
28. Ask if you want Google Analytics and setup with supplied urchin code

After each major change it does a git commit as well to keep things tidy :)

Credits
=======

This is created from our work at reinteractive.

License
=======

(The MIT License)

Copyright (c) 2016

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
