require './gamesman'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Gamesman
  end

  def test_main
    get '/'
    assert last_response.ok?
  end

  def test_coffee_js
    File.open('assets/javascripts/test.js.coffee', 'w')
    get '/javascripts/test.js'
    assert last_response.ok?
    File.delete('assets/javascripts/test.js.coffee')
  end

  def test_raw_js
    File.open('assets/javascripts/test.js','w') { |f| f.write('hello') }
    get '/javascripts/test.js'
    assert last_response.ok?
    assert_equal 'hello', last_response.body
    File.delete('assets/javascripts/test.js')
  end
end
