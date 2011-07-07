begin # only test if paint is available
require 'paint'

describe Wirb::Colorizer::Paint do
  before :each do
    Wirb.colorizer = Wirb::Colorizer::Paint
  end
  
  it "creates good color codes based on Paint color symbols" do
    Wirb.get_color(:red).should match_colors(31)
    Wirb.get_color(:red, :bright).should match_colors(1,31)
    Wirb.get_color(:bright, :red).should match_colors(1,31)
    Wirb.get_color(:red, :bright, :underline).should match_colors(1,4,31)
    Wirb.get_color(:red, :blue).should match_colors(31,44)
    Wirb.get_color(nil, :blue).should match_colors(44)
    Wirb.get_color([43,86,129]).should match_colors('38;5;'+(16 + 1*36 + 2*6 + 3*1).to_s)
    Wirb.get_color("medium sea green").should match_colors('38;5;78')
    Wirb.get_color("#81562b").should match_colors('38;5;' + (16 + 3*36 + 2*6 + 1*1).to_s)
    Wirb.get_color("#863").should match_colors('38;5;' + (16 + 3*36 + 2*6 + 1*1).to_s)
    Wirb.get_color(:red, :encircle).should match_colors(52,31)
  end
  
  it "colorizes strings based on Paint color symbols" do
    Wirb.colorize_string('Dantooine', :red, :bright, :underline).should match_colored_string('Dantooine', 1,4,31)
  end
  
  after :each do
    Wirb.colorizer = nil
  end
end

rescue LoadError
end
