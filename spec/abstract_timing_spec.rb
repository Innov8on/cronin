require 'spec_helper'

class FooTiming < Cronin::AbstractTiming
  class << self
    def min_value
      0
    end

    def max_value
      59
    end
  end
end

class BarTiming < Cronin::AbstractTiming
  class << self
    def min_value
      0
    end

    def max_value
      100
    end
  end
end

describe Cronin::AbstractTiming do

  it "should get timming correctly" do
    t = FooTiming.new("*")
    t.timing.should == (0..59).to_a # [0,1,2,3,4,...,59]

    t = FooTiming.new("3")
    t.timing.should == [3]

    t = FooTiming.new("*/2")
    t.timing.should == (0..59).to_a.delete_if {|elem| elem % 2 != 0} # [0,2,4,6,..,58]

    t = FooTiming.new("*/3")
    t.timing.should == (0..59).to_a.delete_if {|elem| elem % 3 != 0} # [0,3,6,9,..,57]

    t = BarTiming.new("*/3")
    t.timing.should == (0..100).to_a.delete_if {|elem| elem % 3 != 0} # [0,3,6,9,..,99]

    t = BarTiming.new("*/30")
    t.timing.should == (0..100).to_a.delete_if {|elem| elem % 30 != 0} # [0,30,60,90]
  end

  it "instance should know about its min and max values" do
    t = FooTiming.new('*')

    t.min_value.should == 0
    t.max_value.should == 59
  end

  it "should not allow wrong arguments" do
    t = FooTiming.new("66")
    expect { t.timing }.to raise_error(ArgumentError)
  end

end

