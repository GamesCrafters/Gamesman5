require 'rspec'
require 'rack/test'
require './gamesman'
require 'capybara/rspec'
require 'capybara-webkit'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL

  conf.order = "random"
end

Capybara.app = Gamesman.new

Capybara.javascript_driver = :webkit
Capybara.default_wait_time = 1

if Capybara.javascript_driver == :webkit
  require 'headless'

  headless = Headless.new
  headless.start

  at_exit do
    headless.destroy
  end
end
