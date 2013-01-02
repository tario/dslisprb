require "dslisprb"

describe DsLisp, "ds lisp variables"  do
  it "should evaluate variables on if" do
    DsLisp.new.evaluate("((lambda (x) (if (> x 2) x 2)) 3)").should be == 3
  end

  it "should assign variables via let" do
    DsLisp.new.evaluate("(let ((a 5)) a)").should be == 5
  end

  it "should assign multiple variables via let" do
    DsLisp.new.evaluate("(let ((a 5) (b 6)) (+ a b) )").should be == 11
  end
end

