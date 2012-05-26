require "dslisprb"

describe DsLisp, "ds lisp flow control"  do
  it "should execute second statement of if when first statement return true" do
    DsLisp.new.evaluate([:if, :T, [:+, 110, 1], [:+, 220, 2]]).should be == 111
  end 

  it "should execute third statement of if when first statement return false" do
    DsLisp.new.evaluate([:if, :nil, [:+, 110, 1], [:+, 220, 2]]).should be == 222
  end 

  it "should return nil when first statement return false and there is no second statement" do
    DsLisp.new.evaluate([:if, :nil, [:+, 110, 1]]).should be == nil
  end

  it "should execute cond statement" do
    DsLisp.new.evaluate([:cond, [:T, [:+, 120, 3]]]).should be == 123
  end 

  it "should execute second statement of cond if the first fail" do
    DsLisp.new.evaluate([:cond, [:nil, [:+, 120, 3]], [:T, [:+, 120, 5]]]).should be == 125
  end 
end

