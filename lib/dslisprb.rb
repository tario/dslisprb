class DsLisp
  def parse(str)
    if str =~ /^\d+$/
      str.to_i
    else
      str.to_sym
    end
  end
end

