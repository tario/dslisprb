require "dslisprb"

describe DsLisp, "ds lisp"  do
  def self.test_func(a,b,value)
    it "(#{a} #{value}) should be equivalent to (#{b} #{value}#{")"*b.count("(")})" do
      DsLisp.new.evaluate("(#{a} '#{value})").should be == DsLisp.new.evaluate("(#{b} '#{value}#{")"*b.count("(")})")
    end 
  end

  test_func("caar","car ( car", "((1 2) (3 4))")
  test_func("cadr","car ( cdr", "((1 2) (3 4))")
  test_func("cdar","cdr ( car", "((1 2) (3 4))")
  test_func("cddr","cdr ( cdr", "((1 2) (3 4))")

end

