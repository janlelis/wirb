# Colorizer for using HighLine colors with Wirb
#
# Automatically translates Wirb color to Highline colors: 
#   HighLineConnector.color(s, :brown_underline) #=> calls HighLine.color(s, :yellow, :underline)
#
# You can mix and match using HighLine color names and Wirb color names. Prefix HighLine color names
# with :highline. For instance:
#
#   Wirb.colorizer.run(s, :highline, :yellow) #=> calls HighLine.color(s, :yellow)
#   Wirb.colorizer.run(s, :yellow)            #=> calls HighLine.color(s, :bold, :yellow) because 
#                                             #   Wirb uses :yellow to mean bold yellow

require 'highline'

module Wirb::Colorizer::Wirb0_HighLine
  def self.color(*colors)
    ::HighLine.color_code(*color_name(*colors))
  end
  
  def self.run(s, *colors)
    ::HighLine.color(s, *color_name(*colors))
  end
  

  def self.color_name(*colors)
    colors = colors.flatten.compact
    if colors.first == :highline # In this case, colors already use HighLine's names
      colors[1..-1]
    else
      translated_colors = colors.map do |color|
        color = color.to_s
        case color
        when "nothing"
          color = "clear"
        when /light_gray/
           color = color.sub("light_gray", "white")
        when /dark_gray/
           color = color.sub("dark_gray", "light_black")  # Changed to [:bold, :black] below
        when /yellow/
          color = color.sub("yellow", "light_yellow")     # Changed to [:bold, :yellow] below
        when /white/
           color = color.sub("white", "light_white")      # Changed to [:bold, :white] below
        when /brown/              
          color = color.sub("brown", "yellow")
        when /purple/             
          color = color.sub("purple", "magenta")
        end
        color_set = [color.to_sym]
        if color_set.first.to_s =~ /^light_(.*)/
          color_set[0] = $1.to_sym
          color_set << :bold
        end
        case color_set.first.to_s
        when /(.*)_underline$/
          color_set[0] = [$1.to_sym]
          color_set << :underline
        when /(.*)_background$/
          color_set[0] = [('on_'+$1).to_sym]
        end
        color_set
      end
      translated_colors.flatten
    end
  end
 
  def color_code(*args)
    self.class.color_code(*args)
  end
  
  def color(*args)
    self.class.color(*args)
  end
end
