require_relative 'wirb/version'
require_relative 'wirb/tokenizer'

require 'yaml'
require 'paint'
require 'timeout'

class << Wirb
  def running?
    !!@running
  end

  def timeout
    @timeout ||= 3
  end

  def schema
    @schema ||= load_schema
  end


  def start
    require File.dirname(__FILE__) + '/wirb/irb' if defined?(IRB) && defined?(IRB::Irb) && !IRB::Irb.instance_methods.include?(:prompt_non_fancy)
    @running = true
  rescue LoadError
    warn "Couldn't activate Wirb"
  end
  alias activate start
  alias enable   start

  def stop
    @running = false
  end
  alias deactivate stop
  alias disable    stop

    def schema=(val)
    @schema = val
  end

  # Loads a color schema from a yaml file
  #   If first argument is a String: path to yaml file
  #   If first argument is a Symbol: bundled schema
  def load_schema(yaml_path = :classic)
    schema_name, schema_yaml = resolve_schema_yaml(yaml_path)
    raise LoadError, "Could not load the Wirb schema at: #{yaml_path}" unless schema_yaml.is_a?(Hash)

    @schema = normalize_schema(schema_yaml)
    @schema[:name] = schema_name.to_sym
    @schema
  end

  def resolve_schema_yaml(yaml_path)
    if yaml_path.is_a? Symbol # bundled themes
      [yaml_path.to_s, YAML.load_file(File.join(Gem.datadir('wirb'), "#{yaml_path}.yml"))]
    else
      [File.basename(yaml_path).gsub(/\.yml$/, ''), YAML.load_file(yaml_path)]
    end
 end

  def normalize_schema(schema_yaml)
    normalized_schema = Hash[ schema_yaml.map{ |k,v| [k.to_s.to_sym, Array( v )] } ]
    %w(
      hash
      array
      set
      object
      symbol_string_delimiter
      string_delimiter
      regexp_delimiter
      rational
      complex
    ).each{ |what|
      values = normalized_schema.delete(what.to_sym)
      normalized_schema[:"open_#{what}"]  = values
      normalized_schema[:"close_#{what}"] = values
    }

    normalized_schema
  end

  def colorize_result(string)
    if @running
      check = ''
      begin
        colorful = Wirb::Tokenizer.run(string).map{ |kind, token|
          check << token
          Paint[token, *Array( schema[kind] )]
        }.join
      rescue
        p $!, $!.backtrace[0] if $VERBOSE
      end

      # always display the correct inspect string!
      check == string ? colorful : string
    else
      string
    end
  end

  def colorize_result_with_timeout(string)
    if timeout.to_i == 0
      colorize_result(string)
    else
      Timeout.timeout(timeout) do
        colorize_result(string)
      end
    end
  rescue Timeout::Error
    string
  end

end

# J-_-L

