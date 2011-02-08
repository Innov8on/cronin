require 'spec_helper'

describe Cronin::WeekDays do
  it 'should has proprer max value' do
    Cronin::WeekDays.max_value.should == 6
  end

  it 'should has proprer min value' do
    Cronin::WeekDays.min_value.should == 0
  end

  it 'should inherited from AbstractTiming' do
    Cronin::WeekDays.superclass.should == Cronin::AbstractTiming
  end

  it 'should respond to restricted? method' do
    c = Cronin::WeekDays.new("*")
    c.respond_to?(:restricted?).should be_true
  end

end
