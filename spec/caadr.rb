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

  test_value_3 = "(((1 2) (3 4)) ((5 6) (7 8)))"
  test_func("caaar","car ( car ( car", test_value_3)
  test_func("caadr","car ( car ( cdr", test_value_3)
  test_func("cadar","car ( cdr ( car", test_value_3)
  test_func("caddr","car ( cdr ( cdr", test_value_3)
  test_func("cdaar","cdr ( car ( car", test_value_3)
  test_func("cdadr","cdr ( car ( cdr", test_value_3)
  test_func("cddar","cdr ( cdr ( car", test_value_3)
  test_func("cdddr","cdr ( cdr ( cdr", test_value_3)

end

