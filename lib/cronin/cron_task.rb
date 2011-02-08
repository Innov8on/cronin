require 'date'

module Cronin
  class CronTask
    
    def initialize(entry)
      @parsed_entry = Parser.new(entry).parse
    end

    def executions(start_time, end_time)
      raise 'end date can not be earlier then start date' if end_time < start_time
      @start_time = start_time
      @end_time   = end_time
      get_executions
    end

    def get_executions
      start_day  = Date.parse(time_to_string(@start_time))
      end_day    = Date.parse(time_to_string(@end_time))
      executions = []
      execution_days.each do |day|
        if start_day == day
          execution_hours = daily_execution_hours(:start_hour => @start_time.hour, :start_minute => @start_time.min)
        end
        if end_day == day
          execution_hours = daily_execution_hours(:end_hour => @end_time.hour, :end_minute => @end_time.min)
        end
        if end_day == start_day
          options = {
            :start_hour   => @start_time.hour,
            :start_minute => @start_time.min,
            :end_hour     => @end_time.hour, 
            :end_minute   => @end_time.min
          }
          execution_hours = daily_execution_hours(options)
        end
        if end_day != day && start_day != day
          execution_hours = daily_execution_hours
        end
        execution_hours.each do |hour|
          executions << Time.mktime(day.year,day.month,day.day,hour.hour,hour.minute) 
        end
      end 
      executions
    end

    def execution_days
      get_days.select do |day|
        wday_mday = if both_wday_and_mday_are_restricted?
          (@parsed_entry[:week_days].timing.include?(day.wday) ||
          @parsed_entry[:month_days].timing.include?(day.mday))
        else
          (@parsed_entry[:week_days].timing.include?(day.wday) &&
          @parsed_entry[:month_days].timing.include?(day.mday))
        end
        # maybe it is to long?
        # @parsed_entry[:week_days].timing
        wday_mday && @parsed_entry[:months].timing.include?(day.month)
      end
    end

    def both_wday_and_mday_are_restricted?
      @parsed_entry[:week_days].restricted? &&
      @parsed_entry[:month_days].restricted?
    end
    private :both_wday_and_mday_are_restricted?


    def get_days
      start_day = Date.parse(time_to_string(@start_time))
      end_day   = Date.parse(time_to_string(@end_time))
      if start_day == end_day
        return [start_day]   
      else
        return (start_day..end_day).to_a
      end
    end

    def daily_execution_hours(options = {})
      options = {:start_hour => 0, :start_minute => 0, :end_hour => 23, :end_minute => 59}.merge(options)
      execution_hours = []
      hours   = @parsed_entry[:hours].timing
      hours   = hours.select {|hour| options[:start_hour] <= hour }
      hours   = hours.select {|hour| options[:end_hour] >= hour }
      minutes = @parsed_entry[:minutes].timing 
      hours.each do |hour|
        _minutes = if hour == options[:start_hour]
          minutes.select { |minute| options[:start_minute] <= minute }
        else
          minutes
        end
        _minutes = if hour == options[:end_hour]
          _minutes.select { |minute| options[:end_minute] >= minute }
        else
          _minutes
        end
        _minutes.each do |minute|
          execution_hours << Cronin::Hour.new(hour,minute)
        end
      end
      execution_hours
    end

    def time_to_string(time)
      "#{time.year}-#{time.month}-#{time.day}"
    end
    private :time_to_string

  end
end
