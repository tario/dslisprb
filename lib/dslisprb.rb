class DsLisp
  def parse(str)
    if matchdata = /^\s*\((.*)\)\s*$/.match(str)
      inside_code = matchdata[1]
      if inside_code =~ /^\s*$/
        []
      else
        [ parse(matchdata[1]) ]
      end
    else
      if str =~ /^\s*\d+\s*$/
        str.to_i
      else
        str.to_sym
      end
    end
  end
end

