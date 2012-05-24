class DsLisp
  def parse(str)
    if str =~ /^\s*\d+\s*$/
      str.to_i
    else
      str.to_sym
    end
  end
end

