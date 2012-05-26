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
end

