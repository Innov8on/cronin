module Cronin
  class WeekDays < AbstractTiming
    include Restricted
    
    class << self
      def min_value
        0
      end

      def max_value
        6
      end
    end
  end
end
