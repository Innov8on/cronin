require 'spec_helper'

describe Cronin::Months do
  it 'should has proprer max value' do
    Cronin::Months.max_value.should == 12
  end

  it 'should has proprer min value' do
    Cronin::Months.min_value.should == 1
  end

  it 'should inherited from AbstractTiming' do
    Cronin::Months.superclass.should == Cronin::AbstractTiming
  end

end
