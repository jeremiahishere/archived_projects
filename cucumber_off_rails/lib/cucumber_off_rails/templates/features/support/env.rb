# debugger
# require 'ruby-debug19'

# RSpec
require 'rspec/expectations'

# Cucumber setup
require 'capybara/cucumber'
require 'capybara/session'
require 'capybara/mechanize'
require 'cucumber/formatter/unicode'

Capybara.run_server = false
Capybara.app_host = 'http://www.google.com'
Capybara.default_selector = :css
Capybara.default_driver = :mechanize
# no selenium support for now
# Capybara.javascript_driver = :selenium

@@user = { :email => "userlogin@yoursitehere.com", :password => "password" }
