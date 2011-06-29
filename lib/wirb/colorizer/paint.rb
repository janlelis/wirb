require 'paint'

module Wirb::Colorizer::Paint
  def self.run(string, *color_args)
    ::Paint[string, *color_args]
  end

  def self.color(*color_args)
    ::Paint.color(*color_args)
  end
end
