module Wirb
  module Colorizer
    class << self
      # Tries to find colorizer
      def const_missing(colorizer)
        path = File.dirname(__FILE__) + '/colorizer/' + colorizer.to_s.downcase

        begin
          require path
        rescue LoadError
          warn "Colorizer #{colorizer} could not be found at: #{path}"
        end

        eval "#{colorizer}" # better method available?
      end
    end
  end
end
