require 'spec_helper'

describe Cronin::Hours do
  it 'should has proprer max value' do
    Cronin::Hours.max_value.should == 23
  end

  it 'should has proprer min value' do
    Cronin::Hours.min_value.should == 0
  end

  it 'should inherited from AbstractTiming' do
    Cronin::Hours.superclass.should == Cronin::AbstractTiming
  end

end
