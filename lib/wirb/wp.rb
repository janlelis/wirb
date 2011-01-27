require File.dirname(__FILE__) + '/../wirb' unless defined? Wirb

module Kernel
  private

  def wp(object, color = nil)
    if color
      puts Wirb.colorize_string object.inspect, color
    else
      puts Wirb.colorize_result object.inspect
    end
  end
end
