require "dslisprb"

describe DsLisp::CommonLispFunctions, "ds lisp functions"  do
  it "should return 1 for (car (quote (1 2)))" do
    DsLisp.new.evaluate([:car, [:quote, [1, 2]]]).should be == 1
  end 
end


