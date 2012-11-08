require 'sinatra'
require 'sinatra/content_for'

require 'xml'
require 'coffee-script'

class Game < Sinatra::Base
  helpers Sinatra::ContentFor

  get '/game/:name/new' do
    erb :new
  end
end

class CoffeeEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/javascripts/games'

  get '/javascripts/games/*.js' do
    coffee params[:splat].first.to_sym
  end
end

class Gamesman < Sinatra::Base
  use CoffeeEngine
  use Game
  helpers Sinatra::ContentFor

  get '/' do
    @games = {}
    Dir.glob("public/xml/games/*.xml") do |file|
      parts = file.split('/')
      asset_name = parts[-1].split('.')[0]

      parser = XML::Parser.file(file)

      game = parser.parse

      if !game.find_first('//game/hidden').nil? && params[:admin] != "true"
        next
      end

      title = game.find_first('//game/title').content
      description = game.find_first('//game/description').content
      tags = []
      game.find_first('//game/tags').children.each do |child|
        if child.name != 'text' && !child.name.nil? && !child.name.empty?
          puts child
          puts child.name
          tags << child.name
        end
      end

      @games[asset_name] = [title, description, tags]
    end
    erb :index
  end
end
