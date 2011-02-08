module Cronin
  class Minutes < AbstractTiming
    
    class << self
      def min_value
        0
      end

      def max_value
        59
      end
    end
  end
end
