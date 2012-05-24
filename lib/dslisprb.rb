class DsLisp

  module CommonLispFunctions
    class << self
      def +(a,b); a+b; end
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
    # generate ruby code for lisp ast
    ruby_code = to_ruby(code)
    eval(ruby_code)
  end

private
  def to_ruby(code)
    if Array === code
      # lisp call

      function_name = code.first
      if function_name == :quote
        code[1].inspect
      else      
        strargs = code[1..-1].map{|x| "("+to_ruby(x)+")"}.join(",")
        "CommonLispFunctions.#{code.first}(#{strargs})"
      end    
    else
      code.inspect  
    end
  end
end

