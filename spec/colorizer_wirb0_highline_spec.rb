begin # only test if highline is available
require 'highline'

describe Wirb::Colorizer::Wirb0_HighLine do
  before :each do
    Wirb.colorizer = Wirb::Colorizer::Wirb0_HighLine
  end
  
  it "creates good color codes based on Highline color symbols" do
    Wirb.get_color(:highline, :reverse, :underline, :magenta).should == "\e[7m\e[4m\e[35m"
  end
  
  it "colorizes strings based on Highline color symbols" do
    Wirb.colorize_string('Dantooine', :highline, :blink, :on_red).should == "\e[5m\e[41mDantooine\e[0m"
  end
  
  it_behaves_like "a Wirb0 colorizer"
  
  context "when using basic color names" do
    it "understands the differences between HighLine and Wirb0" do
      Wirb.get_color(:nothing).should match_colors(0)                              # Wirb0 calls this nothing
      Wirb.get_color(:highline, :clear).should match_colors(0)                     # HighLine calls it clear
    
      Wirb.get_color(:brown).should match_colors(0,33)                             # Wirb0 calls this brown
      Wirb.get_color(:highline, :yellow).should match_colors(0,33)                 # HighLine calls it yellow
    
      Wirb.get_color(:purple).should match_colors(0,35)                            # Wirb0 calls this purple
      Wirb.get_color(:highline, :magenta).should match_colors(0,35)                # HighLine calls it magenta
    
      Wirb.get_color(:light_gray).should match_colors(0,37)                        # Wirb0 calls this light_gray
      Wirb.get_color(:highline, :white).should match_colors(0,37)                  # HighLine calls it white
    
      Wirb.get_color(:light_black).should match_colors(1,30)                       # Wirb0 calls this light_black
      Wirb.get_color(:highline, :bold, :black).should match_colors(1,30)           # HighLine calls it bold black
    
      Wirb.get_color(:yellow).should match_colors(1,33)                            # Wirb0 calls this yellow
      Wirb.get_color(:highline, :bold, :yellow).should match_colors(1,33)          # HighLine calls it bold yellow
    
      Wirb.get_color(:white).should match_colors(1,37)                             # Wirb0 calls this white
      Wirb.get_color(:highline, :bold, :white).should match_colors(1,37)           # HighLine calls it bold white
    end
  end
    
  context "when using light/bold colors" do
    it "understands the differences between HighLine and Wirb0" do
      Wirb.get_color(:light_purple).should match_colors(1,35)                      # Wirb0 says :light_<color>
      Wirb.get_color(:highline, :magenta, :bold).should match_colors(1,35)         # HighLine says :bold, :<color>
    end
  end
    
  context "when using underlined colors" do
    it "understands the differences between HighLine and Wirb0" do
      Wirb.get_color(:light_gray_underline).should match_colors(4,37)              # Wirb0 says :<color>_underline
      Wirb.get_color(:highline, :underline, :white).should match_colors(4,37)      # HighLine says :underline, :<color>
    end
  end

  context "when using background colors" do
    it "understands the differences between HighLine and Wirb0" do
      Wirb.get_color(:brown_background).should match_colors(43)                    # Wirb0 says :<color>_background
      Wirb.get_color(:highline, :on_yellow).should match_colors(43)                # HighLine says :on_<color>
    end
  end
    
  context "when encoding strings" do
    it "understands the differences between HighLine and Wirb0" do
      Wirb.colorize_string('Alderaan', :purple).should match_colored_string('Alderaan', 35)             # Wirb0 calls this purple
      Wirb.colorize_string('Alderaan', :highline, :magenta).should match_colored_string('Alderaan', 35) # HighLine calls it magenta
    end
  end
  
  after :each do
    Wirb.colorizer = nil
  end
end

rescue LoadError
end
