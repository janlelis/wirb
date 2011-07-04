require File.dirname(__FILE__) + '/wirb/version'
require File.dirname(__FILE__) + '/wirb/colorizer'
require File.dirname(__FILE__) + '/wirb/schema'
require File.dirname(__FILE__) + '/wirb/tokenizer'

class << Wirb
  attr_accessor :schema

  @running = false

  def running?() @running end

  # Return the escape code for a given color
  def get_color(*keys)
    colorizer.color(*keys)
  end
  alias color get_color
  
  # Colorize a string
  def colorize_string(string, *colors)
    colorizer.run(string, *colors)
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
  
  def colorizer=(colorizer)
    @colorizer=colorizer
  end
  
  # Convenience method, permits simplified syntax like:
  #   Wirb.colorize_with :HighLine
  def colorize_with(colorizer_name)
    @colorizer = Wirb::Colorizer.const_get(colorizer_name)
  end
  
  # Jan: Note change to lazy evaluation
  def colorizer
    @colorizer ||= Wirb::Colorizer::Wirb0 # Jan: IMHO, should use Wirb0 not Paint, because Paint depends on an external gem
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
