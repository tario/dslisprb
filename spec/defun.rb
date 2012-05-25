require "dslisprb"

describe DsLisp, "ds lisp defun"  do
  it "should allow lambda" do
    DsLisp.new.evaluate([:lambda, [:x], [:+, :x, 1]]).call(1).should be == 2
  end

  it "should allow lambda assign and call" do
    DsLisp.new.evaluate([:block, 
            [:set, :lambda_test, [:lambda, [:x], [:+, :x, 1]]], 
            [:lambda_test, 1]
            ]).should be == 2
  end

end


