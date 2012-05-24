require "dslisprb"

describe DsLisp, "ds lisp"  do

  (1..10).each do |i|
    it "should parse simple numeric atom #{i}" do
      DsLisp.new.parse(i.to_s).should be == i
    end 
  end

  (1..10).each do |i|
    it "should parse simple numeric atom #{i} with spaces around" do
      DsLisp.new.parse("  " + i.to_s + "   ").should be == i
    end 
  end

  [:x,:y,:z].each do |symbol|
    it "should parse simple symbolic atom #{symbol}" do
      DsLisp.new.parse(symbol.to_s).should be == symbol
    end 
  end

end

