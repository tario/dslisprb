class DsLisp
  module CommonLispOperators
    class << self
      def quote(code)
        code[1].inspect
      end
    end
  end

  def parse(str)
    if matchdata = /^\s*\((.*)\)\s*$/.match(str)
      inside_code = matchdata[1]
      if inside_code =~ /^\s*$/
        []
      else
        # split tokens preserving parenthesis count
        tokens = []
        newtoken = ""
        inside_code.split.each do |str|
          newtoken << " "
          newtoken << str
          if newtoken.count("(") == newtoken.count(")")
            tokens << newtoken
            newtoken = ""          
          end
        end

        tokens.map(&method(:parse))
      end
    else
      if str =~ /^\s*\d+\s*$/
        str.to_i
      else
        str.strip.to_sym
      end
    end
  end

  def evaluate(code)
    # arithmethic
    plus = lambda{|x,y| x+y}
    mult = lambda{|x,y| x*y}
    divide = lambda{|x,y| x/y}
    minus = lambda{|x,y| x-y}

    lt = lambda{|x,y| x<y || nil}
    ht = lambda{|x,y| x>y || nil}
    _eq = lambda{|x,y| x==y || nil}

      
    # list selectors
    _car = lambda{|x| x.first}
    _cdr = lambda{|x| x[1..-1]}
    _nth = lambda{|index,list| list[index-1]}

    # list constructors
    _cons = lambda{|element, list| [element]+list}
    _append = plus
    _list = lambda{|*args| args}

    # recognizers
    _null = lambda{|element| (element == nil or element == []) || nil}
    _atom = lambda{|element| (not Array === element) || nil}
    _numberp = lambda{|element| Numeric === element || nil}
    _symbolp = lambda{|element| Symbol === element || nil}
    _listp = lambda{|element| Array === element || nil}
    _length = lambda{|list| list.size}

    # nil
    _nil = lambda{nil}

    # boolean
    _not = lambda{|a| (not a) || nil}
    _and = lambda{|a,b| (a and b) || nil}
    _or = lambda{|a,b| (a or b) || nil}

    # generate ruby code for lisp ast
    ruby_code = to_ruby(code)
    eval(ruby_code)
  end

private

  def name_convert(name)
    {:< => "lt", :> => "ht", :+ => "plus", :* => "mult" , :/ => "divide", :- => "minus" }[name] || "_" + name.to_s
  end

  def to_ruby(code)
    if Array === code
      # lisp call

      function_name = code.first

      if (CommonLispOperators.methods - Class.methods).include?(function_name)
        CommonLispOperators.send(function_name, code)
      else      
        strargs = code[1..-1].map{|x| "("+to_ruby(x)+")"}.join(",")

        if Symbol === function_name
          "#{name_convert(function_name)}.call(#{strargs})"
        else
          "#{to_ruby(code.first)}.call(#{strargs})"
        end
      end    
    else
      code.inspect  
    end
  end
end

