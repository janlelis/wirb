module Wirb
  module Colors
    # These are colors to provide compatibility with Wirble.
    # You can define your own by doing by adding a method to Wirb::Colors
    #
    # A simple example:
    #   class << Wirb::Colors
    #     def mycolor string
    #       string.foreground(:red).background(:blue).bright
    #     end
    #   end
    #
    # Then configure wirb to use it.
    #   Wirb.schema[:string] = :mycolor
    #
    # See Wirb.schema.keys for the different colors you can change.

    class << self
      def nothing s
        s.reset
      end
      def brown s
        s.foreground :yellow
      end
      def purple s
        s.foreground :magenta
      end
      def light_gray s
        s.foreground :white
      end
      def light_gray s
        s.foreground :white
      end
      def dark_gray s
        s.bright.foreground :black
      end
      def light_red s
        s.bright.foreground :red
      end
      def light_green s
        s.bright.foreground :green
      end
      def light_blue s
        s.bright.foreground :blue
      end
      def light_purple s
        s.bright.foreground :magenta
      end
      def light_cyan s
        s.bright.foreground :cyan
      end

      def black_underline s
        s.underline.foreground :black
      end
      def red_underline s
        s.underline.foreground :red
      end
      def green_underline s
        s.underline.foreground :green
      end
      def brown_underline s
        s.underline.foreground :yellow
      end
      def blue_underline s
        s.underline.foreground :blue
      end
      def purple_underline s
        s.underline.foreground :magenta
      end
      def cyan_underline s
        s.underline.foreground :cyan
      end
      def white_underline s
        s.underline.foreground :white
      end
      def black_background s
        s.background :black
      end
      def red_background s
        s.background :red
      end
      def green_background s
        s.background :green
      end
      def brown_background s
        s.background :yellow
      end
      def blue_background s
        s.background :blue
      end
      def purple_background s
        s.background :magenta
      end
      def cyan_background s
        s.background :cyan
      end
      def white_background s
        s.background :white
      end

    end
  end
end

# J-_-L
