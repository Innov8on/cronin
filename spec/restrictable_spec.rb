require 'spec_helper'

class RestrictedTest < Cronin::AbstractTiming
  include Cronin::Restricted

  class << self
    def min_value
      0
    end

    def max_value
      59
    end
  end
end

describe RestrictedTest do

  it "should be restricted" do
    r = RestrictedTest.new("1")
    r.restricted?.should be_true

    r = RestrictedTest.new("11")
    r.restricted?.should be_true

    r = RestrictedTest.new("*/2")
    r.restricted?.should be_true
  end

  it "should not be restricted" do
    r = RestrictedTest.new("*")
    r.restricted?.should be_false
  end
end

