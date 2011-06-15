require File.expand_path( File.dirname(__FILE__) + '/wirb/version' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/colors' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/schema' )
require File.expand_path( File.dirname(__FILE__) + '/wirb/tokenizer' )
require 'rainbow'

class << Wirb
  attr_accessor :schema

  @running = false
  def running?() @running end

  # Colorize a string
  def colorize_string(string, *color)
    if color.length == 3 and color.reduce(true) {|acc, x| acc and x.is_a? Fixnum}
      # This is for specifying RGB colors.
      return string.color color
    else
      if color.length != 1 or not (color[0].is_a? Symbol or color[0].nil? or color[0].is_a? String)
        raise "Expected a color symbol, html-style hex-value or nil, got: #{color.inspect}"
      end
      color = color[0]
      if color.nil?
        return string
      elsif color.is_a? String
        return string.foreground color
      elsif Wirb::Colors::respond_to? color
        return Wirb::Colors.send(color, string)
      else
        return string.foreground color
      end
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
