require 'spec_helper'

describe Cronin::Minutes do
  it 'should has proprer max value' do
    Cronin::Minutes.max_value.should == 59
  end

  it 'should has proprer min value' do
    Cronin::Minutes.min_value.should == 0
  end

  it 'should inherited from AbstractTiming' do
    Cronin::Minutes.superclass.should == Cronin::AbstractTiming
  end

end
