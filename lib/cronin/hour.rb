module Cronin
  class Hour

    attr_reader :hour, :minute
    def initialize(hour,minute)
      @hour   = hour
      @minute = minute
    end

    def ==(other)
      other.hour == self.hour && other.minute == self.minute
    end
  end
end
