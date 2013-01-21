class DsLisp
  class ToRuby
    class << self

      def convert_name(name)
        {:lt => "<", :ht => :>, :plus => :+, :mult => "*", :divide => "/", :minus => "-" }[name] || name[1..-1]
      end

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
            strargs = code[1..-1].map{|x| 
              "(#{to_ruby(x)})"
            }.join(",")

            "#{to_ruby(code.first)}.call(#{strargs})"
          end    
        else
          if code == :nil
            "nil"
          elsif code == :T
            "true"
          elsif Symbol === code
            "eval(\"#{name_convert(code).to_s}\")" 
          else
            code.inspect
          end  
        end
      end    
    end
  end

  module CommonLispOperators
    class << self
      def quote(code)
        code[1].inspect
      end

      def cond(code)
        "(nil.tap { 
        " + code[1..-1].map{ |condition_code|
          "(break (#{ToRuby.to_ruby condition_code[1]}) if (aux = (#{ToRuby.to_ruby condition_code[0]}); aux != [] and aux != nil) )"
        }.join(";") + "})"
      end

      def if(code)
        "(if (aux = (#{ToRuby.to_ruby code[1]}); aux != [] and aux != nil)
            #{ToRuby.to_ruby code[2]}
          else
            #{ToRuby.to_ruby code[3]}
          end
         )
         "
      end

      def let(code)
        newcode = [[:lambda, code[1].map(&:first), code[2]]] + code[1].map{|x|x[1]}
        ToRuby.to_ruby(newcode)
      end

      def lambda(code)
        arguments = code[1].select{|x| x != :"&optional"}.map{|x| Array === x ? x[0] : x}.map(&ToRuby.method(:name_convert)).map(&:to_s)
        x_optional = code[1].select{|x| x != :"&optional"}.map{|x|
            if Array === x
              ToRuby.to_ruby(x[1])
            else
              "nil"
            end
        }

        @count = (@count || 0) + 1
        oldargsvar = "oldargs_#{@count}"

        "(lambda{|*x|
            #{oldargsvar} = [ #{arguments.map{|z| "begin; #{z}; rescue; nil; end"}.join(",")} ] # save current bindings
            #{(0..arguments.size-1).map{|i| "#{arguments[i]} = x[#{i}] || #{x_optional[i]}" }.join(";")} 
            begin
              aux = #{ToRuby.to_ruby(code[2])}
            ensure
              #{(0..arguments.size-1).map{|i| "#{arguments[i]} = #{oldargsvar}[#{i}]" }.join(";")}
            end
            aux
          }.lisp_inner_code(#{code.lisp_inspect.inspect}))"
      end

      def block(code)
        code[1..-1].map(&ToRuby.method(:to_ruby)).join(";")
      end

      def set(code)
        "#{ToRuby.name_convert(code[1])} = #{ToRuby.to_ruby(code[2])}"
      end

      def defun(code)
        newcode = [:set, code[1], [:lambda, code[2], code[3]]] 
        ToRuby.to_ruby(newcode)
      end

      def defmacro(code)
        name = code[1]
        arguments = code[2]
        impl = code[3][1]

        subsl = Kernel.lambda{|_code, rplmap|
          _code.map{|subcode|
            if Array === subcode
              subsl.call(subcode, rplmap)
            else
              rplmap[subcode] || subcode
            end
          }
        }

        CommonLispOperators.define_singleton_method(name) do |_code|
          rplmap = {}          
          (0..arguments.size-1).each do |i|
            rplmap[arguments[i]] = _code[i+1]
          end

          ToRuby.to_ruby subsl.call(impl, rplmap)
        end

        ""
      end
    end
  end

  def parse(str)
    if str =~ /;;.*$/
      return parse(str.gsub(/;;.*$/,""))
    end

    if str["\n"]
      return parse(str.gsub("\n",""))
    end

    if str.count("(") != str.count(")")
      raise "Parentheshis count does not match, try adding parenthesis at the end of string :P"
    end

    if matchdata = /^\s*\'(.*)\s*$/.match(str)
      [:quote, parse(matchdata[1])]
    elsif matchdata = /^\s*\((.*)\)\s*$/.match(str)
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
      elsif str =~ /^\s*nil\s*$/
        nil
      else
        str.strip.to_sym
      end
    end
  end

  def evaluate(code)
    if String === code
      return evaluate(parse code)
    end

    # generate ruby code for lisp ast
    ruby_code = ToRuby.to_ruby(code)
    eval(ruby_code, main_binding)
  end

  def variables
    eval("local_variables", main_binding).map(&ToRuby.method(:convert_name))
  end

private
  def null(element)
    element == nil or element == []
  end

  def not_null(element)
    element != nil and element != []
  end

  def main_binding
    unless @binding
      @binding = binding

      # arithmethic
      plus = lambda{|x,y| x+y}
      mult = lambda{|x,y| x*y}
      divide = lambda{|x,y| x/y}
      minus = lambda{|x,y| x-y}

      lt = lambda{|x,y| x<y || nil}
      ht = lambda{|x,y| x>y || nil}
      _eq = lambda{|x,y| x==y || nil}

        
      # list selectors
      _car = lambda{|x| x ? x.first : nil}
      _cdr = lambda{|x| x ? x[1..-1] : nil}
      _nth = lambda{|index,list| list[index-1]}

      # nested list selectors
      _caar = lambda{|x| x[0][0]}
      _cadr = lambda{|x| x[1..-1][0]}
      _cdar = lambda{|x| x[0][1..-1]}
      _cddr = lambda{|x| x[1..-1][1..-1]}

      _caaar = lambda{|x| x[0][0][0]}
      _caadr = lambda{|x| x[1..-1][0][0]}
      _cadar = lambda{|x| x[0][1..-1][0]}
      _caddr = lambda{|x| x[1..-1][1..-1][0]}
      _cdaar = lambda{|x| x[0][0][1..-1]}
      _cdadr = lambda{|x| x[1..-1][0][1..-1]}
      _cddar = lambda{|x| x[0][1..-1][1..-1]}
      _cdddr = lambda{|x| x[1..-1][1..-1][1..-1]}

      # list constructors
      _cons = lambda{|element, list| [element]+list.to_a}
      _append = lambda{|*args| args.inject(&:+)}
      _list = lambda{|*args| args}

      # recognizers
      _null = lambda{|element| null(element) ? true : nil}
      _atom = lambda{|element| (not Array === element) || nil}
      _numberp = lambda{|element| Numeric === element || nil}
      _symbolp = lambda{|element| Symbol === element || nil}
      _listp = lambda{|element| Array === element || nil}
      _length = lambda{|list| list.size}

      # nil
      _nil = lambda{nil}

      # boolean
      _not = lambda{|a| null(a) ? true : nil}
      _and = lambda{|a,b| (not_null(a) and not_null(b)) ? b : nil}
      _or = lambda{|a,b| 
          if not_null(a)
            a
          else
            b
          end 
      }


      as_function = lambda{|object|
        if Symbol === object
          eval(ToRuby.name_convert(object),@binding)
        elsif Array === object
          evaluate(object)
        else
          object
        end
      }

      _mapcan = lambda{|function, list|
        list.map(&as_function.call(function)).map{|x|
          x || [] 
        }.inject(&:+)
      }

      _mapcar = lambda{|function, list| list.map(&as_function.call(function))}
      _apply = lambda{|function, arguments| as_function.call(function).call(*arguments) }    
      _funcall = lambda{|function, *arguments| as_function.call(function).call(*arguments) }

      _reverse = :reverse.to_proc

      _p = lambda{|a| p a}  
    end
    @binding
  end
end

class Object
  def lisp_inspect
    inspect
  end
end

class Symbol
  def lisp_inspect
    to_s
  end
end

class TrueClass
  def lisp_inspect
    "T"
  end
end

class Array
  def lisp_inspect
    "(" + map(&:lisp_inspect).join(" ") + ")"  
  end
end

class Proc
  def lisp_inspect
    @inner_code
  end

  def lisp_inner_code(code)
    @inner_code = code
    self
  end
end

