# Jan:
#   General philosophical question: Would it be more flexible to have @colorizer point
#   to an _instance_ of a Colorizer object, rather than a Colorizer class? (And therefore
#   to have run and color be instance methods of Colorizer, rather than class methods.)
#   In certain circumstances this could give greater flexibility, for instance to set 
#   colorizer options...

module Wirb
  module Colorizer
    class << self
      def const_missing(colorizer)
        path = File.dirname(__FILE__) + '/colorizer/' + colorizer.to_s.downcase

        begin
          require path
        rescue LoadError => e
          raise LoadError, "Could not load colorizer #{colorizer} at #{path}: #{e}"
        end
        
        raise LoadError, "Colorizer definition at #{path} does not appear to define #{self}::#{colorizer}" \
          unless const_defined?(colorizer)
        const_get colorizer
      end
    end
  end
end
