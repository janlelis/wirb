require_relative 'wirb/version'
require_relative 'wirb/tokenizer'
require_relative 'wirb/schema_builder'
require_relative 'wirb/inspector'
require_relative 'wirb/irb' if defined?(IRB)

require 'yaml'
require 'paint'
require 'timeout'


module Wirb
  class << self
    def running?
      defined?(IRB) && IRB.CurrentContext &&
      IRB.CurrentContext.inspect_mode == :wirb
    end

    def timeout
      @timeout ||= 3
    end

    def schema
      @schema ||= SchemaBuilder.load_schema_from_yaml
    end

    def schema=(val)
      @schema = val
    end

    def load_schema(name)
      @schema = SchemaBuilder.load_schema_from_yaml(name)
    end

    def original_inspect_mode
      @original_inspect_mode
    end

    def start
      require_relative 'wirb/irb'
      @original_inspect_mode =
        IRB.conf[:INSPECT_MODE] ||
        IRB.CurrentContext && IRB.CurrentContext.inspect_mode ||
        true
      IRB.conf[:INSPECT_MODE] = :wirb
      IRB.CurrentContext.inspect_mode = :wirb if IRB.CurrentContext
      true
    end
    alias activate start
    alias enable   start

    def stop
      if running?
        IRB.conf[:INSPECT_MODE] = @original_inspect_mode
        IRB.CurrentContext.inspect_mode = @original_inspect_mode if IRB.CurrentContext
        true
      end
    end
    alias deactivate stop
    alias disable    stop

    def colorize_result(string, _deprecated = nil)
      check = ''
      colorful = ''
      begin
        Tokenizer.run(string).each{ |kind, token|
          check << token
          colorful << Paint[token, *Array( schema[kind] )]
        }
      rescue
        p $!, $!.backtrace[0] if $VERBOSE
      end

      # always display the correct inspect string!
      check == string ? colorful : string
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
end
