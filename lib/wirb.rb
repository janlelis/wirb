require_relative 'wirb/version'
require_relative 'wirb/tokenizer'
require_relative 'wirb/schema_builder'

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
    @schema ||= Wirb::SchemaBuilder.load_schema_from_yaml
  end

  def schema=(val)
    @schema = val
  end

  def load_schema(name)
    @schema = Wirb::SchemaBuilder.load_schema_from_yaml(name)
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

  def colorize_result(string)
    if @running
      check = ''
      colorful = ''
      begin
        Wirb::Tokenizer.run(string).each{ |kind, token|
          check << token
          colorful << Paint[token, *Array( schema[kind] )]
        }
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

