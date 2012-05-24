require "dslisprb"

describe DsLisp::CommonLispFunctions, "ds lisp functions"  do

  # selectors
  it "should return 1 for (car (quote (1 2)))" do
    DsLisp.new.evaluate([:car, [:quote, [1, 2]]]).should be == 1
  end

  it "should return (2 3) for (cdr (quote (1 2 3)))" do
    DsLisp.new.evaluate([:cdr, [:quote, [1, 2, 3]]]).should be == [2, 3]
  end

  it "should return 5 for (nth 2 (quote (4 5 6)))" do
    DsLisp.new.evaluate([:nth, 2, [:quote, [4, 5, 6]]]).should be == 5
  end

  # constructors
  it "should return (1 2 3 4) for (cons 1 (quote (2 3 4)))" do
    DsLisp.new.evaluate([:cons, 1, [:quote, [2, 3, 4]]]).should be == [1,2,3,4]
  end

  it "should return (1 2 3 4 5) for (append (quote (1 2)) (quote (3 4 5)))" do
    DsLisp.new.evaluate([:append, [:quote, [1,2]], [:quote, [3, 4, 5]]]).should be == [1,2,3,4,5]
  end

  it "should return (1 2) for (list 1 2)" do
    DsLisp.new.evaluate([:list, 1, 2]).should be == [1,2]
  end

  it "should return (1 2 3) for (list 1 2 3)" do
    DsLisp.new.evaluate([:list, 1, 2, 3]).should be == [1,2,3]
  end

  # type recognizers
  [:a, 1, [1,2,3,4], [], nil].each do |obj|
    result = (obj == nil or obj == []) ? true : nil
    it "should return #{result} for (null #{obj})" do
      DsLisp.new.evaluate([:null, [:quote, obj]]).should be == result
    end
  end

  [:a, 1, [1,2,3,4]].each do |obj|
    result = (not Array === obj) ? true : nil
    it "should return #{result} for (atom #{obj})" do
      DsLisp.new.evaluate([:atom, [:quote, obj]]).should be == result
    end

    numberp_result = (Numeric === obj) ? true : nil
    it "should return #{result} for (numberp #{obj})" do
      DsLisp.new.evaluate([:numberp, [:quote, obj]]).should be == numberp_result
    end

    symbolp_result = (Symbol === obj) ? true : nil
    it "should return #{result} for (symbolp #{obj})" do
      DsLisp.new.evaluate([:symbolp, [:quote, obj]]).should be == symbolp_result
    end

    listp_result = (Array === obj) ? true : nil
    it "should return #{result} for (listp #{obj})" do
      DsLisp.new.evaluate([:listp, [:quote, obj]]).should be == listp_result
    end
  end

  [[1], [1,2], [1,2,3], [1,2,3,4]].each do |obj|
    result = obj.size
    it "should return #{result} for (length #{obj})" do
      DsLisp.new.evaluate([:length, [:quote, obj]]).should be == result
    end
  end
end


