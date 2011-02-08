module Cronin
  class Months < AbstractTiming
    
    class << self
      def min_value
        1
      end

      def max_value
        12
      end
    end
  end
end
