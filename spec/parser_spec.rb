require 'spec_helper'

describe Cronin::Parser do
  it "should parse cron entry" do
    parsed = Cronin::Parser.new("1 2 3 4 5").parse

    parsed.count.should == 5

    parsed[:minutes].class.should == Cronin::Minutes
    parsed[:minutes].instance_eval { @cron_value }.should == '1'

    parsed[:hours].class.should == Cronin::Hours
    parsed[:hours].instance_eval { @cron_value }.should == '2'

    parsed[:month_days].class.should == Cronin::MonthDays
    parsed[:month_days].instance_eval { @cron_value }.should == '3'

    parsed[:months].class.should == Cronin::Months
    parsed[:months].instance_eval { @cron_value }.should == '4'

    parsed[:week_days].class.should == Cronin::WeekDays
    parsed[:week_days].instance_eval { @cron_value }.should == '5'

    parsed = Cronin::Parser.new("1 2 3 4 5 run some command").parse

    parsed.count.should == 5

    parsed[:minutes].class.should == Cronin::Minutes
    parsed[:minutes].instance_eval { @cron_value }.should == '1'

    parsed[:hours].class.should == Cronin::Hours
    parsed[:hours].instance_eval { @cron_value }.should == '2'

    parsed[:month_days].class.should == Cronin::MonthDays
    parsed[:month_days].instance_eval { @cron_value }.should == '3'

    parsed[:months].class.should == Cronin::Months
    parsed[:months].instance_eval { @cron_value }.should == '4'

    parsed[:week_days].class.should == Cronin::WeekDays
    parsed[:week_days].instance_eval { @cron_value }.should == '5'
  end

end
