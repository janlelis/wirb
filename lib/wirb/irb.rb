require File.dirname(__FILE__) + '/../wirb' unless defined? Wirb

class IRB::Irb
  alias :output_value_without_wirb :output_value

  def output_value
    if @context.inspect?
      printf @context.return_format, ::Wirb.colorize_result( @context.last_value.inspect )
    else
      printf @context.return_format, @context.last_value
    end
  end
end
