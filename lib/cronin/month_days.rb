module Cronin
  class MonthDays < AbstractTiming
    include Restricted
    
    class << self
      def min_value
        1
      end

      def max_value
        31
      end
    end
  end
end
