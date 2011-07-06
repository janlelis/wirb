module Wirb::Colorizer::Wirb0
  COLORS = {
    :nothing      => '0;0',

    # light
    :black        => '0;30',
    :red          => '0;31',
    :green        => '0;32',
    :brown        => '0;33',
    :blue         => '0;34',
    :purple       => '0;35',
    :cyan         => '0;36',
    :light_gray   => '0;37',
    
    # bold
    :dark_gray    => '1;30',
    :light_red    => '1;31',
    :light_green  => '1;32',
    :yellow       => '1;33',
    :light_blue   => '1;34',
    :light_purple => '1;35',
    :light_cyan   => '1;36',
    :white        => '1;37',

    # underline
    :black_underline   => '4;30',
    :red_underline     => '4;31',
    :green_underline   => '4;32',
    :brown_underline   => '4;33',
    :blue_underline    => '4;34',
    :purple_underline  => '4;35',
    :cyan_underline    => '4;36',
    :white_underline   => '4;37',

    # background
    :black_background   => '7;30',
    :red_background     => '7;31',
    :green_background   => '7;32',
    :brown_background   => '7;33',
    :blue_background    => '7;34',
    :purple_background  => '7;35',
    :cyan_background    => '7;36',
    :white_background   => '7;37',
  }

  def self.run(string, *color_args)
    color(*color_args) + string.to_s + color(:nothing)
  end

  def self.color(*color_args)
    color_args.first && COLORS[color_args.first.to_sym] ? "\e[#{COLORS[color_args.first.to_sym]}m" : ''
  end
end   
