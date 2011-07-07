begin # only test if highline is available
require 'highline'

describe Wirb::Colorizer::HighLine do
  before :each do
    Wirb.colorizer = Wirb::Colorizer::HighLine
  end
  
  it "creates good color codes based on Highline color symbols" do
    Wirb.get_color(:reverse, :underline, :magenta).should match_colors(4,7,35)
  end
  
  it "colorizes strings based on Highline color symbols" do
    Wirb.colorize_string('Dantooine', :blink, :on_red).should match_colored_string('Dantooine', 5,41)
  end
  
  after :each do
    Wirb.colorizer = nil
  end
end

rescue LoadError
end
