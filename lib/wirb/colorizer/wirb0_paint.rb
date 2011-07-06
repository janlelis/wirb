require 'paint'

Paint::SHORTCUTS[:wirb] = {
  :nothing      => Paint::NOTHING,

  # light
  :black        => Paint.color(:black),
  :red          => Paint.color(:red),
  :green        => Paint.color(:green),
  :brown        => Paint.color(:yellow),
  :blue         => Paint.color(:blue),
  :purple       => Paint.color(:magenta),
  :cyan         => Paint.color(:cyan),
  :light_gray   => Paint.color(:white),
  
  # bold
  :dark_gray    => Paint.color(:black, :bold),
  :light_red    => Paint.color(:red, :bold),
  :light_green  => Paint.color(:green, :bold),
  :yellow       => Paint.color(:yellow, :bold),
  :light_blue   => Paint.color(:blue, :bold),
  :light_purple => Paint.color(:magenta, :bold),
  :light_cyan   => Paint.color(:cyan, :bold),
  :white        => Paint.color(:white, :bold),

  # underline
  :black_underline   => Paint.color(:black, :underline),
  :red_underline     => Paint.color(:red, :underline),
  :green_underline   => Paint.color(:green, :underline),
  :brown_underline   => Paint.color(:yellow, :underline),
  :blue_underline    => Paint.color(:blue, :underline),
  :purple_underline  => Paint.color(:magenta, :underline),
  :cyan_underline    => Paint.color(:cyan, :underline),
  :white_underline   => Paint.color(:white, :underline),

  # background
  :black_background   => Paint.color(nil, :black), # first color passed is foreground, second one is background
  :red_background     => Paint.color(nil, :red),
  :green_background   => Paint.color(nil, :green),
  :brown_background   => Paint.color(nil, :yellow),
  :blue_background    => Paint.color(nil, :blue),
  :purple_background  => Paint.color(nil, :magenta),
  :cyan_background    => Paint.color(nil, :cyan),
  :white_background   => Paint.color(nil, :white),
}

module Wirb::Colorizer::Wirb0_Paint
  def self.run(string, *color_args)
    if color_args.first && color_args.size == 1 && color_args.first.is_a?(Symbol)
      if color_args.first == :paint # force usage of paint colors
        Paint[string, *color_args[1..-1]]
      else
        Paint::Wirb.send(color_args.first, string)
      end
    else
      Paint[string, *color_args]
    end
  end

  def self.color(*color_args)
    if color_args.first && color_args.size == 1 && color_args.first.is_a?(Symbol)
      if color_args.first == :paint # force usage of paint colors
        Paint[string, *color_args[1..-1]]
      else
        Paint::Wirb.send(color_args.first)
      end
    else
      Paint.color(*color_args)
    end
  end
end
