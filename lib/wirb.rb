require File.expand_path( File.dirname(__FILE__) + '/wirb/version' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/colors' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/schema' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/tokenizer' )

class << Wirb
  attr_accessor :schema

  # Return the escape code for a given color
  def get_color(key)
    if key.is_a? String
      color = key
    elsif Wirb::COLORS.key?(key)
      color = Wirb::COLORS[key]
    end

    color ? "\033[#{ color }m" : ''
  end

  # Colorize a string
  def colorize_string(string, color)
    get_color(color) + string.to_s + get_color(:nothing)
  end

  # Colorize a result string
  def colorize_result(string, custom_schema = schema)
    check = ''
    colorful = tokenize(string).map do |kind, token|
      check << token
      colorize_string token, custom_schema[kind]
    end.join

    # always display the correct inspect string!
    check == string ? colorful : string
  end

  # Colorize results in irb/ripl (or whatever might be supported in future)
  def start
    require File.dirname(__FILE__) + '/wirb/irb'
  rescue LoadError
    warn "Couldn't activate Wirb for #{which}"
  end
  alias activate start
  alias enable start
end

# J-_-L
