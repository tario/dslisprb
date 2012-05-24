require "dslisprb"

describe DsLisp, "ds lisp execution"  do

  (1..10).each do |i|
    it "should evaluate simple numeric atom #{i}" do
      DsLisp.new.evaluate(i).should be == i
    end 
  end

  [:x,:y,:z].each do |symbol|
    it "should parse simple symbolic atom #{symbol}" do
      DsLisp.new.evaluate(symbol).should be == symbol
    end 
  end
end

