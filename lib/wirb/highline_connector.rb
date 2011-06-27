# Connector for using HighLine colors with Wirb
#
# Automatically translates Wirb color to Highline colors: 
#   HighLineConnector.color(s, :brown_underline) #=> calls HighLine.color(s, :yellow, :underline)
#
# You can mix and match using HighLine color names and Wirb color names. Prefix HighLine color names
# with :highline. For instance:
#
#   HighLineConnector.color(s, :highline, :yellow) #=> calls HighLine.color(s, :yellow)
#   HighLineConnector.color(s, :yellow)            #=> calls HighLine.color(s, :bold, :yellow) because 
#                                                  #   Wirb uses :yellow to mean bold yellow
#
# Note: HighLine library must be required separately

class WirbHighLineConnector
  def self.translate_colors(*colors)
    colors = colors.flatten.compact
    if colors.first == :highline # In this case, colors already use HighLine's names
      colors[1..-1]
    else
      translated_colors = colors.map do |color|
        color = color.to_s
        case color
        when "nothing"
          color = "clear"
        when "light_gray"
           color = "white"
        when "dark_gray"
           color = "light_black"  # Changed to [:bold, :black] below
        when "yellow"
           color = "light_yellow" # Changed to [:bold, :yellow] below
        when "white"
           color = "light_white"  # Changed to [:bold, :white] below
        when /brown/              # Uses regexp to handle :brown_underline, etc.
          color = color.sub("brown", "yellow")
        when /purple/             # Uses regexp to handle :purple_underline, etc.
          color = color.sub("purple", "magenta")
        end
        case color
        when /^light_(.*)/
          color = [$1.to_sym, :bold]
        when /(.*)_underline$/
          color = [$1.to_sym, :underline]
        when /(.*)_background$/
          color = ('on_' + $1).to_sym
        else
          color = color.to_sym
        end
      end
      translated_colors.flatten
    end
  end
  
  def self.color_code(*colors)
    HighLine.color_code(*translate_colors(*colors))
  end
  
  def self.color(s, *colors)
    HighLine.color(s, *translate_colors(*colors))
  end
  
  def color_code(*args)
    self.class.color_code(*args)
  end
  
  def color(*args)
    self.class.color(*args)
  end
end
