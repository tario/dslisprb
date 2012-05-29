require "dslisprb"

describe DsLisp, "ds lisp stack"  do
  it "should change variable value on lambda call" do

    dslisp = DsLisp.new

    dslisp.evaluate("(set x 100)")
    dslisp.evaluate("(set foo1 (lambda (z) (+ x z)))")
    dslisp.evaluate("(set foo2 (lambda (x) (foo1 4)))")
    dslisp.evaluate("(foo2 3)").should be == 7
  end
end

