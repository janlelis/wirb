require File.dirname(__FILE__) + '/../wirb' unless defined? Wirb

module Kernel
  private

  def wp(object)
    puts Wirb.colorize_result object.inspect
  end
end
