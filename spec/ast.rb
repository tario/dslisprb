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

  it "should parse empty list" do
    DsLisp.new.parse('()').should be == []
  end

  it "should parse list with atom inside" do
    DsLisp.new.parse('(1)').should be == [1]
  end 

  it "should parse list with two atoms inside" do
    DsLisp.new.parse('(1 2)').should be == [1, 2]
  end 

  it "should parse list with a list with two atoms inside" do
    DsLisp.new.parse('((1 2))').should be == [[1, 2]]
  end 

  it "should parse list with two list with two atoms inside" do
    DsLisp.new.parse('((1 2) (3 4))').should be == [[1, 2],[3, 4]]
  end 

  it "should parse list with two list with two symbolic atoms inside" do
    DsLisp.new.parse('((a b) (c d))').should be == [[:a, :b],[:c, :d]]
  end

  it "should parse quote with atoms" do
    DsLisp.new.parse("'car").should be == [:quote, :car]
  end 

  it "should parse quote with lists" do
    DsLisp.new.parse("'(1 2 3)").should be == [:quote, [1,2,3]]
  end

  it "should parse nil" do
    DsLisp.new.parse("nil").should be == nil
  end

  it "should parse quoted empty list" do
    DsLisp.new.parse("'()").should be == [:quote, []]
  end

  it "should parse nested quotes" do
    DsLisp.new.parse("'(car '(1 2 3))").should be == [:quote, [:car, [:quote, [1, 2, 3]]]]
  end
end

