require File.dirname(__FILE__) + '/wirb/version'
require File.dirname(__FILE__) + '/wirb/colorizer'
require File.dirname(__FILE__) + '/wirb/schema'
require File.dirname(__FILE__) + '/wirb/tokenizer'

class << Wirb
  attr_accessor :schema, :colorizer

  @running = false

  def running?() @running end

  # Return the escape code for a given color
  def get_color(*keys)
    @colorizer.color(*keys)
  end
  alias color get_color
  
  # Colorize a string
  def colorize_string(string, *colors)
    @colorizer.run(string, *colors)
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
    @colorizer ||= Wirb::Colorizer::Wirb0Paint
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
