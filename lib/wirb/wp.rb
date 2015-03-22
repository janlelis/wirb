require_relative '../wirb'

module Kernel
  private

  def wp(object)
    puts Wirb.colorize_result object.inspect
  end
end
