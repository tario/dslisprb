require "dslisprb"

describe DsLisp, "ds lisp"  do

  (1..10).each do |i|
    it "should parse simple atom" do
      DsLisp.new.parse(i.to_s).should be == i
    end 
  end
end

