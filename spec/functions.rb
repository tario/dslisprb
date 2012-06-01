require "dslisprb"

describe DsLisp, "ds lisp functions"  do

  # selectors
  it "should return 1 for (car (quote (1 2)))" do
    DsLisp.new.evaluate([:car, [:quote, [1, 2]]]).should be == 1
  end

  it "should return (2 3) for (cdr (quote (1 2 3)))" do
    DsLisp.new.evaluate([:cdr, [:quote, [1, 2, 3]]]).should be == [2, 3]
  end

  it "should return 5 for (nth 2 (quote (4 5 6)))" do
    DsLisp.new.evaluate([:nth, 2, [:quote, [4, 5, 6]]]).should be == 5
  end

  # constructors
  it "should return (1 2 3 4) for (cons 1 (quote (2 3 4)))" do
    DsLisp.new.evaluate([:cons, 1, [:quote, [2, 3, 4]]]).should be == [1,2,3,4]
  end

  it "should return (1 2 3 4 5) for (append (quote (1 2)) (quote (3 4 5)))" do
    DsLisp.new.evaluate([:append, [:quote, [1,2]], [:quote, [3, 4, 5]]]).should be == [1,2,3,4,5]
  end

  it "should return (1 2) for (list 1 2)" do
    DsLisp.new.evaluate([:list, 1, 2]).should be == [1,2]
  end

  it "should return (1 2 3) for (list 1 2 3)" do
    DsLisp.new.evaluate([:list, 1, 2, 3]).should be == [1,2,3]
  end

  # type recognizers
  [:a, 1, [1,2,3,4], [], nil].each do |obj|
    result = (obj == nil or obj == []) ? true : nil
    it "should return #{result} for (null #{obj})" do
      DsLisp.new.evaluate([:null, [:quote, obj]]).should be == result
    end
  end

  [:a, 1, [1,2,3,4]].each do |obj|
    result = (not Array === obj) ? true : nil
    it "should return #{result} for (atom #{obj})" do
      DsLisp.new.evaluate([:atom, [:quote, obj]]).should be == result
    end

    numberp_result = (Numeric === obj) ? true : nil
    it "should return #{result} for (numberp #{obj})" do
      DsLisp.new.evaluate([:numberp, [:quote, obj]]).should be == numberp_result
    end

    symbolp_result = (Symbol === obj) ? true : nil
    it "should return #{result} for (symbolp #{obj})" do
      DsLisp.new.evaluate([:symbolp, [:quote, obj]]).should be == symbolp_result
    end

    listp_result = (Array === obj) ? true : nil
    it "should return #{result} for (listp #{obj})" do
      DsLisp.new.evaluate([:listp, [:quote, obj]]).should be == listp_result
    end
  end

  [[1], [1,2], [1,2,3], [1,2,3,4]].each do |obj|
    result = obj.size
    it "should return #{result} for (length #{obj})" do
      DsLisp.new.evaluate([:length, [:quote, obj]]).should be == result
    end
  end

  # arithmetic
  it "should call +" do
    DsLisp.new.evaluate([:+,1,2]).should be == 3
  end

  it "should call -" do
    DsLisp.new.evaluate([:-,7,4]).should be == 3
  end

  it "should call *" do
    DsLisp.new.evaluate([:*,5,6]).should be == 30
  end

  it "should call /" do
    DsLisp.new.evaluate([:/,10,2]).should be == 5
  end

  # relational
  [[3,2],[3,3],[3,4]].each do |pair|
    result = pair.first < pair.last || nil
    it "should call <" do
      DsLisp.new.evaluate([:<,pair.first,pair.last]).should be == result
    end

    resultht = pair.first > pair.last || nil
    it "should call >" do
      DsLisp.new.evaluate([:>,pair.first,pair.last]).should be == resultht
    end

    resulteq = pair.first == pair.last || nil
    it "should call eq" do
      DsLisp.new.evaluate([:eq,pair.first,pair.last]).should be == resulteq
    end
  end

  # boolean
  [[true,true],[true,nil],[nil,true],[nil,nil]].each do |pair|
    resultor = (pair.first or pair.last) || nil
    resultand = (pair.first and pair.last) || nil
    resultnot = (not pair.first) || nil

    it "should call or with #{pair} and return #{resultor}" do
      DsLisp.new.evaluate([:or,pair.first,pair.last]).should be == resultor
    end

    it "should call and with #{pair} and return #{resultand}" do
      DsLisp.new.evaluate([:and,pair.first,pair.last]).should be == resultand
    end

    it "should call not" do
      DsLisp.new.evaluate([:not,pair.first]).should be == resultnot
    end
  end

  it "should execute mapcan" do
    DsLisp.new.evaluate("(mapcan (lambda (x) (and (numberp x) (list x))) '(a 1 b c 3 4 d 5))").should be == [1, 3, 4, 5]
  end

  it "should execute mapcar" do
    DsLisp.new.evaluate("(mapcar (lambda (x) (+ x 1)) '(1 2 3 4))").should be == [2, 3, 4, 5]
  end

  it "should execute mapcar with defined function" do
    dslisp = DsLisp.new
    dslisp.evaluate("(defun foo (x) (+ x 1))")
    dslisp.evaluate("(mapcar foo '(1 2 3 4))").should be == [2, 3, 4, 5]
  end

  it "should interpret nil symbol as nil" do
    DsLisp.new.evaluate(:nil).should be == nil
  end

  it "should interpret T symbol as true" do
    DsLisp.new.evaluate(:T).should be == true
  end

  it "should execute apply with symbol function" do
    DsLisp.new.evaluate("(apply 'car '((1 2 3)))").should be == 1
  end

  it "should execute apply with lambda" do
    DsLisp.new.evaluate("(apply (lambda (x) (car x)) '((1 2 3)))").should be == 1
  end

  it "should execute apply with quoted lambda" do
    DsLisp.new.evaluate("(apply '(lambda (x) (car x)) '((1 2 3)))").should be == 1
  end

  it "should execute funcall with symbol function" do
    DsLisp.new.evaluate("(funcall 'car '(1 2 3))").should be == 1
  end

  it "should execute apply with lambda" do
    DsLisp.new.evaluate("(funcall (lambda (x) (car x)) '(1 2 3))").should be == 1
  end

  it "should execute apply with quoted lambda" do
    DsLisp.new.evaluate("(funcall '(lambda (x) (car x)) '(1 2 3))").should be == 1
  end

end


