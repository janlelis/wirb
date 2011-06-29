require 'highline'

module Wirb::Colorizer::HighLine
  @HighLine = ::HighLine.new

  class << self

    def run(string, *color_args)
      @HighLine.color(string, *color_args.flatten)
    end

    def color(*color_args)
      @HighLine.color_code(*color_args.flatten)
    end
  end
end
