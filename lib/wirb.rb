require File.dirname(__FILE__) + '/wirb/version'
require File.dirname(__FILE__) + '/wirb/colorizer'
require File.dirname(__FILE__) + '/wirb/tokenizer'
require 'yaml'

class << Wirb
  def running?() @running end

  @running = false

  # Start colorizing results, will hook into irb if IRB is defined
  def start
    require File.dirname(__FILE__) + '/wirb/irb' if defined?(IRB) && !IRB::Irb.instance_methods.include?(:prompt_non_fancy)
    @running = true
  rescue LoadError
    warn "Couldn't activate Wirb"
  end
  alias activate start
  alias enable   start

  # Stop colorizing
  def stop
    @running = false
  end
  alias deactivate stop
  alias disable    stop

  # extend getter & setter for colorizer & schema
  def colorizer
    @colorizer ||= Wirb::Colorizer::Wirb0
  end

  def colorizer=(col)
    @colorizer = col
  end

  # Convenience method, permits simplified syntax like:
  #   Wirb.load_colorizer :HighLine
  def load_colorizer(colorizer_name)
    # @colorizer = Wirb::Colorizer.const_get(colorizer_name, false)
    @colorizer = eval "Wirb::Colorizer::#{colorizer_name}"
    compatible_colorizer?(@colorizer)
    @colorizer
  end

  def schema
    @schema || load_schema
  end

  def schema=(val)
    @schema = val
  end

  # Loads a color schema from a yaml file
  #   If first argument is a String: path to yaml file
  #   If first argument is a Symbol: bundled schema
  def load_schema!(yaml_path = :classic_wirb0)
    if yaml_path.is_a? Symbol # bundled themes
      schema_name = yaml_path.to_s
      schema_yaml = YAML.load_file(File.join( Gem.datadir('wirb'), schema_name + '.yml' ))
    else
      schema_name = File.basename(yaml_path).gsub(/\.yml$/, '')
      schema_yaml = YAML.load_file(yaml_path)
    end

    if schema_yaml.is_a?(Hash)
      @schema = Hash[ schema_yaml.map{ |k,v|
        [k.to_s.to_sym, Array( v )]
      } ]
      @schema[:name] = schema_name.to_sym
      @schema[:colorizer].map!(&:to_sym)
    else
      raise LoadError, "Could not load the Wirb schema at: #{yaml_path}"
    end

    @schema
  end

  # Loads a color schema from a yaml file and sets colorizer to first suggested one in schema
  def load_schema(yaml_path = :classic_wirb0)
    load_schema! yaml_path
    load_colorizer schema[:colorizer].first
    @schema
  end

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
        colorize_string token, *Array( custom_schema[kind] )
      end.join

      # always display the correct inspect string!
      check == string ? colorful : string
    else
      string
    end
  end
  alias colorize_code colorize_result
  alias colorize_ruby colorize_result

  private

  def compatible_colorizer?(col)
    short_col = col.to_s.sub(/^.*::(.*?)$/, '\1').to_sym
    if !col
      warn "No colorizer selected!"
      false
    elsif !Array( @schema[:colorizer] ).include?(short_col)
      warn "Your current color schema does not support this colorizer:\n" +
           "  #{ short_col }\n" + 
           "The following colorizeres are supported with this schema (use Wirb.load_colorizer :Name):\n  " + 
           Array( @schema[:colorizer] ).join("\n  ")
      false
    else
      true
    end
  end

end

# J-_-L
