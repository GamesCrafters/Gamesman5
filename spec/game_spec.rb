require 'spec_helper'

describe "Game" do
  def app
    Gamesman
  end

  @games = {}
  Dir.glob("assets/xml/games/*.xml") do |file|
    parts = file.split('/')
    asset_name = parts[-1].split('.')[0]

    parser = XML::Parser.file(file)

    game = parser.parse

    if !game.find_first('//game/hidden').nil?
      next
    end

    title = game.find_first('//game/title').content
    description = game.find_first('//game/description').content
    tags = []
    game.find_first('//game/tags').children.each do |child|
      if child.name != 'text' && !child.name.nil? && !child.name.empty?
        tags << child.name
      end
    end

    @games[asset_name] = [title, description, tags]
  end

  @games.each do |resource, parts|
    title, description, tags = parts
    context title do
      before do
        visit '/'
      end

      it "should show up on main page" do
        page.should have_text title
        page.should have_text description
      end

      it "should be able to go to configure page", :js => true do
        click_link title

        page.should have_text title
      end

      context "configure", :js => true do
        before do
          visit "/game/#{resource}/new"
        end

        it "should load settings" do
          page.should have_text title
          page.should have_text "Player Info"
        end


        it "should have config variables" do
          page.evaluate_script("window.game.title").should == title
          page.evaluate_script("window.game.asset").should == resource
        end

        it "should be able to go to play page" do
          click_button "Let's Play!"

          page.should have_selector "canvas#GCAPI-main"
        end
      end

      context "play", :js => true do
        before do
          visit "/game/#{resource}/new"
          click_button "Let's Play!"
        end

        it "should start the game" do
          page.should have_selector "canvas#GCAPI-main"
          page.should have_selector "canvas#GCAPI-control"
        end
      end
    end
  end
end
