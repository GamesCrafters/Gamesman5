require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/assetpack'

require 'xml'
require 'json'
require 'coffee-script'

class Game < Sinatra::Base
  helpers Sinatra::ContentFor
  register Sinatra::AssetPack

  assets do
    serve '/js', :from => '/assets/javascripts'
    serve '/javascripts', :from => '/assets/javascripts/vendor'
    serve '/css', :from => '/assets/stylesheets'

    js :app, [ '/javascripts/jquery-1.8.2.min.js', '/javascripts/modernizr.foundation.js' ]
    js :config, [ '/js/config.js', '/js/GCAPI.js' ]
    js :play, [ '/javascripts/jcanvas.min.js', '/js/play.js', '/js/GCAPI.js',
                '/js/ui.js', '/js/vvh.js' ]

    css :app, [ '/css/app.css', '/css/foundation.min.css' ]
  end

  get '/game/:name/new' do
    erb :new
  end

  get '/game/:name/play' do
    response.headers['Access-Control-Allow-Origin'] = '*'
    erb :play2
  end
end

class CoffeeEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/javascripts/'

  def render_js (name)
    Dir.glob(settings.views + name + "*") do |file|
      if file.end_with?("coffee")
        return coffee file[settings.views.length..-1].chomp(".coffee").to_sym
      end
    end
    File.open(File.join(settings.views, name + '.js')).read()
  end

  get '/javascripts/*.js' do
    render_js params[:splat].first
  end
end

class Gamesman < Sinatra::Base
  #use CoffeeEngine
  #use Game
  helpers Sinatra::ContentFor
  register Sinatra::AssetPack

  assets do
    serve '/js', :from => '/assets/javascripts'
    serve '/javascripts', :from => '/assets/javascripts/vendor'
    serve '/css', :from => '/assets/stylesheets'

    js :app, [ '/javascripts/jquery-1.8.2.min.js', 
               '/javascripts/modernizr.foundation.js',
               '/javascripts/jquery.cookie.js' ]
    js :config, [ '/js/config.js', '/js/GCAPI.js' ]
    js :play, [ '/javascripts/jcanvas.min.js', '/js/play.js', '/js/GCAPI.js',
                '/js/ui.js', '/js/vvh.js', '/js/callWatcher.js' ]

    Dir.glob("assets/javascripts/games/*.{js,coffee}") do |file|
      parts = file.split(/[\/.]/)
      assetName = parts[-2].to_sym
      fileName = "/js/games/#{parts[-2]}.js"
      js assetName, [ fileName ]
    end

    css :app, [ '/css/app.css', '/css/foundation.min.css' ]
  end

  get '/game/:name/new' do
    @title = "Settings"
    erb :new
  end

  get '/game/:name/play' do
    @title = "Play"
    response.headers['Access-Control-Allow-Origin'] = '*'
    erb :play2
  end

  get '/fake/:name/getMoveValue:params' do
    parts = params[:params].split(";")
    parameters = {}
    parts.each do |part|
      if part == ""
        next
      end
      a,b = part.split("=")
      parameters[a] = b
    end
    { :status => "ok", :response => 
      { :board => parameters['board'], :remoteness => 1000, :value => "tie" }
    }.to_json
  end

  get '/fake/:name/getNextMoveValues:params' do
    parts = params[:params].split(";")
    parameters = {}
    parts.each do |part|
      if part == ""
        next
      end
      a,b = part.split("=")
      parameters[a] = b
    end
    { :status => "ok", :response => 
      [ { :board => parameters['board'], :remoteness => 1000, :value => "tie" } ]
    }.to_json
  end

  get '/' do
    @title = "Choose a game"
    @games = {}
    Dir.glob("assets/xml/games/*.xml") do |file|
      parts = file.split('/')
      asset_name = parts[-1].split('.')[0]

      parser = XML::Parser.file(file)

      game = parser.parse
      
      node = nil

      game_object = {}
      if game.find_first('//game')
        node = game.find_first('//game')
      elsif game.find_first('//remote-game')
        node = game.find_first('//remote-game')
        game_object[:url] = node.find_first('//url').content
      end

      if !node.find_first('//hidden').nil? && params[:admin] != "true"
        next
      end

      game_object[:title] = node.find_first('//title').content
      game_object[:description] = node.find_first('//description').content
      game_object[:tags] = []
      node.find_first('//tags').children.each do |child|
        if child.name != 'text' && !child.name.nil? && !child.name.empty?
          game_object[:tags] << child.name
        end
      end

      @games[asset_name] = game_object
    end
    erb :index
  end
end
