require 'rspec'
require 'rack/test'
require './gamesman'
require 'capybara/rspec'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Capybara::DSL

  conf.order = "random"
end

Capybara.app = Gamesman.new
