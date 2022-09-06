# Rails 7 Starter

This repository is an easily-forkable, stripped-back Rails codebase which includes the default gems required for a new rails codebase. It is designed so that it can be picked up and built upon by someone who has never worked with Rails before - there are very little new abstraction required beyond HTML & CSS, and we've intentionally left out things which create additional barriers to beginners such as webpack or npm.  

# To Get Started
- Install ruby 3.1.2 if not already installed
- Install gems with `bundle install`
- Rename `config/application.yml.example` to `config/application.yml`
- Update defaults where preferred
  - Update database names in `config/database.yml` from starter_production, starter_development, starter_test to reflect the app name.
  - Update the `<title>` in `app/views/layouts/application.html.erb` to reflect the app name.
  - Update the default module name in `config/application.rb` to reflect the app name.