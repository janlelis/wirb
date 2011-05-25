require File.expand_path( File.dirname(__FILE__) + '/wirb/version' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/colors' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/schema' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/tokenizer' )

class << Wirb
  attr_accessor :schema

  @running = false
  def running?() @running end

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
    if @running
      check = ''
      colorful = tokenize(string).map do |kind, token|
        check << token
        colorize_string token, custom_schema[kind]
      end.join

      # always display the correct inspect string!
      check == string ? colorful : string
    else
      string
    end
  end

  # Colorize results
  #  Will hook into irb if IRB is defined
  def start
    require File.dirname(__FILE__) + '/wirb/irb' if defined?(IRB)
    @running = true
  rescue LoadError
    warn "Couldn't activate Wirb"
  end
  alias activate start
  alias enable start

  def stop # don't colorize, anymore
    @running = false
  end
  alias deactivate stop
  alias disable stop
end

# J-_-L
