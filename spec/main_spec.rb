require './gamesman'
require 'spec_helper'
require 'capybara/rspec'

describe "Gamesman" do
  include Capybara::DSL
  Capybara.app = Gamesman.new

  def app
    Gamesman
  end

  it "can load /", :js => true do
    visit '/'
    page.should have_text "Games"
  end

  context "Tic Tac Toe" do
    before(:each) do
      visit '/'
    end

    it "can be seen" do
      page.should have_text "Tic Tac Toe"
    end

    it "loads settings page", :js => true do
      click_link "Tic Tac Toe"

      page.should have_text "Tic Tac Toe"
      page.should have_text "Board Width"
      page.should have_text "Board Height"
      page.should have_text "Number in a row"
    end

    it "starts up a game successfully", :js => true do
      click_link "Tic Tac Toe"
      click_button "Let's Play!"

      page.should have_selector ("canvas#GCAPI-main")
      page.should have_selector ("canvas#GCAPI-control")
    end
  end
end
