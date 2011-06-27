require File.dirname(__FILE__) + '/wirb/version'
require File.dirname(__FILE__) + '/wirb/colors'
require File.dirname(__FILE__) + '/wirb/schema'
require File.dirname(__FILE__) + '/wirb/tokenizer'
autoload :WirbHighLineConnector, File.expand_path( File.dirname(__FILE__) + '/wirb/highline_connector.rb' )

class << Wirb
  attr_accessor :schema, :colorizer

  @running = false
  def running?() @running end

  # Return the escape code for a given color
  def get_color(*keys)
    if @colorizer
      @colorizer.color_code(*keys)
    else
      key = keys.first
      if key.is_a? String
        color = key.
      elsif Wirb::COLORS.key?(key)
        color = Wirb::COLORS[key]
      end
      color ? "\033[#{ color }m" : ''
    end
  end
  
  # Shortcut to invoke HighLine. :raw option causes translation of 
  # colors to be disabled (see lib/highline_connector)
  def use_highline(options={})
    if options[:raw]
      self.colorizer=HighLine.new
    else
      self.colorizer=WirbHighLineConnector.new
    end
  end

  # Colorize a string
  def colorize_string(string, *colors)
    colors = colors.flatten
    if @colorizer
      @colorizer.color(string, *colors)
    else
      get_color(colors.first) + string.to_s + get_color(:nothing)
    end
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
