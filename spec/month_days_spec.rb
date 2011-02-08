require 'spec_helper'

describe Cronin::MonthDays do
  it 'should has proprer max value' do
    Cronin::MonthDays.max_value.should == 31
  end

  it 'should has proprer min value' do
    Cronin::MonthDays.min_value.should == 1
  end

  it 'should inherited from AbstractTiming' do
    Cronin::MonthDays.superclass.should == Cronin::AbstractTiming
  end

  it "should respond to restricted? method" do
    c = Cronin::MonthDays.new('*')
    c.respond_to?(:restricted?).should be_true
  end

end
