describe Wirb::Colorizer::Wirble do
  before :each do
    Wirb.colorizer = Wirb::Colorizer::Wirble
  end
  
  it "creates good color codes based on Wirble color symbols" do
    Wirb.get_color(:nothing).should match_colors(0)
    Wirb.get_color(:purple).should match_colors(35)
    Wirb.get_color(:light_gray).should match_colors(37)
    Wirb.get_color(:dark_gray).should match_colors(1,30)
    Wirb.get_color(:yellow).should match_colors(1,33)
    Wirb.get_color(:light_green).should match_colors(1,32)
    Wirb.get_color(:white).should match_colors(1,37)
  end
  
  it "colorizes strings based on Wirble color symbols" do
    Wirb.colorize_string('Dantooine', :cyan).should match_colored_string('Dantooine', 36)
    Wirb.colorize_string('Dantooine', :light_red).should match_colored_string('Dantooine', 1,31)
  end
  
  after :each do
    Wirb.colorizer = nil
  end
end