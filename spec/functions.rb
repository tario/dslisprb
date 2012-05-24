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
end


