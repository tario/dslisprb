require "dslisprb"

describe DsLisp, "ds lisp"  do
  it "should parse simple atom" do
    DsLisp.new.parse("1").should be == 1
  end 
end

