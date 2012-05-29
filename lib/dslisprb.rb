class DsLisp
  class ToRuby
    class << self
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
            nil
          elsif code == :T
            true
          elsif Symbol === code
#            "(local_variables.include?(#{name_convert(code)}) ? #{name_convert(code)} : nil)"
            name_convert(code).to_s 
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

      def lambda(code)
        arguments = code[1].map(&ToRuby.method(:name_convert)).map(&:to_s)
        "(#{arguments.join(",")} = #{code[1].map{"nil"}.join(",")} ;lambda{|*x|
            oldargs = [ #{arguments.join(",")} ] # save current bindings
            #{(0..arguments.size-1).map{|i| "#{arguments[i]} = x[#{i}]" }.join(";")} 
            begin
              aux = #{ToRuby.to_ruby(code[2])}
            ensure
              #{arguments.join(",")} = oldargs # restore bindings
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
    if str.count("(") != str.count(")")
      raise "Parentheshis count does not match, try adding parenthesis at the end of string :P"
    end

    if matchdata = /^\s*\'(.*)\s*$/.match(str)
      [:quote, parse(matchdata[1].sub("'",""))]
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
      _car = lambda{|x| x.first}
      _cdr = lambda{|x| x[1..-1]}
      _nth = lambda{|index,list| list[index-1]}

      # list constructors
      _cons = lambda{|element, list| [element]+list}
      _append = plus
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
        elsif not object.respond_to?(:call)
          lambda{|*x| object}
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

