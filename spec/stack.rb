require "dslisprb"

describe DsLisp, "ds lisp stack"  do
  it "should change variable value on lambda call" do

    dslisp = DsLisp.new

    dslisp.evaluate("(set x 100)")
    dslisp.evaluate("(set foo1 (lambda (z) (+ x z)))")
    dslisp.evaluate("(set foo2 (lambda (x) (foo1 4)))")
    dslisp.evaluate("(foo2 3)").should be == 7
  end

  it "should restore variable f when assigned to list" do

    dslisp = DsLisp.new

    dslisp.evaluate("(defun b (f x)
  (mapcar 
    (lambda (a)
      (a x)
    )

    f
  )
) ".gsub("\n"," "))

    dslisp.evaluate("(set f 100)")
    dslisp.evaluate("(b (list car cdr) '(1 2 3))")
    dslisp.evaluate("f").should be == 100
  end

  it "should restore variable f when assigned to list when assignment occurs before defun" do

    dslisp = DsLisp.new

    dslisp.evaluate("(set f 100)")
    dslisp.evaluate("(defun b (f x)
  (mapcar 
    (lambda (a)
      1
    )

    f
  )
) ".gsub("\n"," "))

    dslisp.evaluate("(b '(list car) '(1 2 3))")
    dslisp.evaluate("f").should be == 100
  end
end

