module Cronin
  # Class contain all logic for getting timing for minute, hour, week day, month day and month
  class AbstractTiming

    def initialize(cron_value)
      @cron_value = cron_value
    end

    # Returns array of fixnum, when it should be execute
    def timing
      case @cron_value
      when '*'
        return (min_value..max_value).to_a
      when /^\d{1,2}/
        number = @cron_value.to_i
        if number >= min_value && number <= max_value
          return [number]
        else
          raise ArgumentError, 'wrong value for this entry'
        end
      when /\*\/(\d+)/
        number = $1.to_i
        return (min_value..max_value).to_a.delete_if {|elem| elem % number != 0}
      end
    end

    def min_value
      self.class.min_value
    end

    def max_value
      self.class.max_value
    end

  end
end
