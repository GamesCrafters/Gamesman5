require './gamesman'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Gamesman
  end

  def test_true
    assert true
    assert true
  end
end
