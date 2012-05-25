require "dslisprb"

describe DsLisp, "ds lisp macro"  do
  it "should allow defmacro and use on different call" do
    dslisp = DsLisp.new
    dslisp.evaluate([:defmacro, :square, [:x], [:quote, [:*, :x, :x]]])
    dslisp.evaluate([:square, 5]).should be == 25
  end
end


