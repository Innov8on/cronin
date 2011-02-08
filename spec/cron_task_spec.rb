require 'spec_helper'

describe Cronin::CronTask do

  it "should store parse result" do
    cron_task  = Cronin::CronTask.new("* * * * *")
    parse_result = cron_task.instance_eval { @parsed_entry }
    parse_result.class.should == Hash
    parse_result.size.should  == 5
  end

  it 'should return execution times' do
    cron_task  = Cronin::CronTask.new("* * * * *")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,22,12,5)

    expected_executions = [
                           Time.mktime(2011,1,22,12,0),
                           Time.mktime(2011,1,22,12,1),
                           Time.mktime(2011,1,22,12,2),
                           Time.mktime(2011,1,22,12,3),
                           Time.mktime(2011,1,22,12,4),
                           Time.mktime(2011,1,22,12,5)
                         ]
    executions = cron_task.executions(start_time, end_time)
    
    executions.should       == expected_executions
    executions.count.should == 6


    cron_task  = Cronin::CronTask.new("0 0 * * * ")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,24,12,5)

    executions = cron_task.executions(start_time, end_time)

    expected_executions = [Time.mktime(2011,1,23,0,0),Time.mktime(2011,1,24,0,0)]
    executions.should       == expected_executions


    cron_task  = Cronin::CronTask.new("0 0 1 * * ")
    start_time = Time.mktime(2010,12,22,12,0)
    end_time   = Time.mktime(2011,1,24,12,5)

    executions = cron_task.executions(start_time, end_time)

    expected_executions = [Time.mktime(2011,1,1,0,0)]
    executions.should   == expected_executions

    cron_task  = Cronin::CronTask.new("0 0 1 1 * ")
    start_time = Time.mktime(2010,12,22,12,0)
    end_time   = Time.mktime(2012,1,24,12,5)

    executions = cron_task.executions(start_time, end_time)

    expected_executions = [Time.mktime(2011,1,1,0,0),Time.mktime(2012,1,1,0,0)]
    executions.should   == expected_executions
  end

  it "start_date should be smaller then end day" do
    cron_task = Cronin::CronTask.new("* * * * *")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,21,12,1)
    
    expect { cron_task.executions(start_time, end_time) }.to raise_error(RuntimeError)
  end

  it "should know days of executions" do
    cron_task  = Cronin::CronTask.new("* * 24 * 6")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,24,12,1)
    
    cron_task.executions(start_time,end_time)

    cron_task.execution_days.should == [Date.new(2011,1,22), Date.new(2011,1,24)]
      
    cron_task  = Cronin::CronTask.new("* * 24 2 6")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,3,24,12,1)
    
    cron_task.executions(start_time,end_time)

    expected = [
      Date.new(2011,2,5),
      Date.new(2011,2,12),
      Date.new(2011,2,19),
      Date.new(2011,2,24),
      Date.new(2011,2,26)
    ]

    cron_task.execution_days.should == expected
  end
  
  it "should properly consider restricted and not restricted wday and mday entries" do
    cron_task  = Cronin::CronTask.new("* * 24 * *")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,3,24,12,1)
    
    cron_task.executions(start_time,end_time)

    expected = [
      Date.new(2011,1,24),
      Date.new(2011,2,24),
      Date.new(2011,3,24)
    ]

    cron_task.execution_days.should == expected
  end

  context "#both_wday_and_mday_are_restricted?" do
    it "should return proper anwser" do
      cron_task = Cronin::CronTask.new("* * 24 * *")
      cron_task.send(:both_wday_and_mday_are_restricted?).should be_false

      cron_task = Cronin::CronTask.new("* * * * 12")
      cron_task.send(:both_wday_and_mday_are_restricted?).should be_false

      cron_task = Cronin::CronTask.new("* * 24 * 12")
      cron_task.send(:both_wday_and_mday_are_restricted?).should be_true

      cron_task = Cronin::CronTask.new("* * * * *")
      cron_task.send(:both_wday_and_mday_are_restricted?).should be_false
    end

    it "should be private" do
      cron_task = Cronin::CronTask.new("* * 24 * *")
      expect { cron_task.both_wday_and_mday_are_restricted? }.to raise_error(NoMethodError)
    end
  end

  context "#daily_execution_hours" do

    it "should return hours of crontab execution" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = (0..23).to_a.map {|hour| Cronin::Hour.new(hour,13) }

      cron_task.send(:daily_execution_hours).should == expected
    end

    it "should be able to pass start hour and minute" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(22,13),
        Cronin::Hour.new(23,13)
      ]
      options = {:start_hour => 21, :start_minute => 14}
      cron_task.send(:daily_execution_hours, options).should == expected
    end

    it "should be able to pass start hour" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(21,13),
        Cronin::Hour.new(22,13),
        Cronin::Hour.new(23,13)
      ]
      cron_task.send(:daily_execution_hours, :start_hour => 21).should == expected
    end

    it "should be able to pass end hour" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(0,13),
        Cronin::Hour.new(1,13),
        Cronin::Hour.new(2,13)
      ]
      cron_task.send(:daily_execution_hours, :end_hour => 2).should == expected
    end

    it "should be able to pass end hour and minute" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(0,13),
        Cronin::Hour.new(1,13)
      ]
      options = {:end_hour => 2, :end_minute => 12}
      cron_task.send(:daily_execution_hours, options).should == expected
    end

    it "should be able to limit end and start hour" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(12,13),
        Cronin::Hour.new(13,13),
        Cronin::Hour.new(14,13),
        Cronin::Hour.new(15,13),
        Cronin::Hour.new(16,13)
      ]
      options = {:end_hour => 16, :start_hour => 12}
      cron_task.send(:daily_execution_hours, options).should == expected
    end

    it "should be able to limit end and start hour and minute" do
      cron_task  = Cronin::CronTask.new("13 * * * *")

      expected = [
        Cronin::Hour.new(13,13),
        Cronin::Hour.new(14,13),
        Cronin::Hour.new(15,13),
      ]
      options = {:end_hour => 16, :start_hour => 12, :start_minute => 14, :end_minute => 12}
      cron_task.send(:daily_execution_hours, options).should == expected
    end

    
  end
    
  it "should know days of execution periods" do
    cron_task  = Cronin::CronTask.new("* * * * *")
    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,22,12,1)

    cron_task.executions(start_time, end_time)

    cron_task.get_days.should == [Date.new(2011,1,22)]


    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2011,1,24,12,1)

    cron_task.executions(start_time, end_time)

    cron_task.get_days.should == [Date.new(2011,1,22), Date.new(2011,1,23), Date.new(2011,1,24)]

    start_time = Time.mktime(2011,1,22,12,0)
    end_time   = Time.mktime(2012,1,24,12,1)

    cron_task.executions(start_time, end_time)

    cron_task.get_days.should == (Date.new(2011,1,22)..Date.new(2012,1,24)).to_a
  end
 
  context "#time_to_string" do
    it "should return string representation of day" do
      cron_task  = Cronin::CronTask.new("* * * * *")
      start_time = Time.mktime(2011,1,22,12,0)
      end_time   = Time.mktime(2011,1,22,12,1)
      
      cron_task.executions(start_time,end_time)
      
      cron_task.send(:time_to_string,start_time).should == "2011-1-22"
    end

    it "should be private" do
      cron_task  = Cronin::CronTask.new("* * * * *")
      start_time = Time.mktime(2011,1,22,12,0)
      end_time   = Time.mktime(2011,1,22,12,1)
      
      cron_task.executions(start_time,end_time)
      
      expect { cron_task.time_to_string(start_time) }.to raise_error(NoMethodError)
    end

  end
 end
