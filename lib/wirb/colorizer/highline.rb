require 'highline'

module Wirb::Colorizer::HighLine
  @highline = ::HighLine.new

  class << self

    def run(string, *color_args)
      @highline.color(string, *color_args.flatten)
    end

    def color(*color_args)
      @highline.color_code(*color_args.flatten)
    end
  end
end
