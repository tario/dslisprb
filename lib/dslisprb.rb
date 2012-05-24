class DsLisp
  def parse(str)
    if matchdata = /^\s*\((.*)\)\s*$/.match(str)
     [ parse(matchdata[1]) ]
    else
      if str =~ /^\s*\d+\s*$/
        str.to_i
      else
        str.to_sym
      end
    end
  end
end

