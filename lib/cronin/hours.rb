module Cronin
  class Hours < AbstractTiming
    
    class << self
      def min_value
        0
      end

      def max_value
        23
      end
    end
  end
end
