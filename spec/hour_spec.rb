require 'spec_helper'

describe Cronin::Hour do

  it "should create new instance" do
    hour = Cronin::Hour.new(12,12)
    hour.class.should == Cronin::Hour
  end

  it "should get hour" do
    hour = Cronin::Hour.new(12,12)
    hour.hour.should == 12
  end

  it "should get minute" do
    hour = Cronin::Hour.new(12,12)
    hour.minute.should == 12
  end

  it "should be equal with other hour with the same values" do
    hour1 = Cronin::Hour.new(12,12)
    hour2 = Cronin::Hour.new(12,12)

    hour1.should == hour2
  end

end
