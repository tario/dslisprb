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

  it "should allow lambda returning 3" do
    DsLisp.new.evaluate([:lambda, [:x], [:+, :x, 2]]).call(1).should be == 3
  end

  it "should allow defun as brief for lambda assign" do
    DsLisp.new.evaluate([:block,
            [:defun, :lambda_test, [:x], [:+, :x, 1]], 
            [:lambda_test, 1]
            ]).should be == 2
  end

  it "should allow recursive funcall" do
    dslisp = DsLisp.new
    dslisp.evaluate([:block,
            [:defun, :a, [:x], [:if, [:>, :x, 0], [:a, [:-, :x, 1] ] ,nil]] 
            ])

    dslisp.evaluate([:a, 3])
  end

  it "should allow recursive funcall between two functions" do
    dslisp = DsLisp.new
    dslisp.evaluate([:block,
            [:defun, :a, [:x], [:if, [:>, :x, 0], [:b, [:-, :x, 1] ] ,nil]],
            [:defun, :b, [:x], [:if, [:>, :x, 0], [:a, [:-, :x, 1] ] ,nil]] 
            ])

    dslisp.evaluate([:a, 3])
  end

  it "nil on list should be evaluated nil" do
    dslisp = DsLisp.new
    dslisp.evaluate("(if (car (cdr '(1 nil 3))) 2 3)").should be == dslisp.evaluate("(if nil 2 3)")
  end 
end


