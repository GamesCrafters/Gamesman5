require 'spec_helper'

describe "Loaders" do
  it "should render coffeescript" do
    File.open('assets/javascripts/test.js.coffee', 'w') do |f|
      f.write('number = -42 if false')
    end
    visit '/javascripts/test.js'
    page.should have_text "(function() { var number; if (false) { number = -42; } }).call(this);"
    File.delete('assets/javascripts/test.js.coffee')
  end

  it "should render raw javascript" do
    File.open('assets/javascripts/test.js', 'w') do |f|
      f.write('number = -42;')
    end
    visit '/javascripts/test.js'
    page.should have_text "number = -42;"
    File.delete('assets/javascripts/test.js')
  end
end
