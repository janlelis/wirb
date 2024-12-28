require 'set'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check( {1=>2} )
    tokens.should == [
      [:open_hash, "{"],
      [:number, "1"],
      ([:whitespace, " "] if hash34?),
      [:refers, "=>"],
      ([:whitespace, " "] if hash34?),
      [:number, "2"],
      [:close_hash, "}"],
    ].compact
  end

  please do check({:hallo => {1=>Set[2,3,4]}})
    tokens.should be_like [
      [:open_hash, "{"],
      [:symbol_prefix, ":"],
      [:symbol, "hallo"],
      [:refers, "=>"],
      [:open_hash, "{"],
      [:number, "1"],
      ([:whitespace, " "] if hash34?),
      [:refers, "=>"],
      ([:whitespace, " "] if hash34?),
      [:open_object, "#<"],
      [:object_class, "Set"],
      [:object_description_prefix, ":"],
      [:whitespace, " "],
      [:open_set, "{"],
      [:number, /\d+/],
      [:comma, ","],
      [:whitespace, " "],
      [:number, /\d+/],
      [:comma, ","],
      [:whitespace, " "],
      [:number, /\d+/],
      [:close_set, "}"],
      [:close_object, ">"],
      [:close_hash, "}"],
      [:close_hash, "}"],
    ].compact
  end

  please do check( {1=>2, 3=>8, {} => {}} )
    tokens.should be_sorted [
      [:close_hash, "}"],
      [:close_hash, "}"],
      [:close_hash, "}"],
      [:comma, ","],
      [:comma, ","],
      [:number, "1"],
      [:number, "2"],
      [:number, "3"],
      [:number, "8"],
      [:open_hash, "{"],
      [:open_hash, "{"],
      [:open_hash, "{"],
      [:refers, "=>"],
      [:refers, "=>"],
      [:refers, "=>"],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
      [:whitespace, " "],
    ]
  end
end
