require "dslisprb"

describe DsLisp, "ds lisp variables"  do
  it "should evaluate variables on if" do
    DsLisp.new.evaluate("((lambda (x) (if (> x 2) x 2)) 3)").should be == 3
  end
end

