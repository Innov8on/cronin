module Cronin
  class Parser
    def initialize(entry)
      @entry = entry
    end

    def parse
      splited = @entry.split[0..4]
      klasses = [Minutes, Hours, MonthDays, Months, WeekDays]
      keys    = [:minutes, :hours, :month_days, :months, :week_days]
      result = {}
      splited.each_with_index do |entry,i|
        result[keys[i]] = klasses[i].new(entry)
      end
      result
    end
  end
end
