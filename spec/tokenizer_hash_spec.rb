require 'set'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check( {1=>2} )
    tokens.should == [
      [:open_hash, "{"],
      [:number, "1"],
      ([:whitespace, " "] if spaced_hashes?),
      [:refers, "=>"],
      ([:whitespace, " "] if spaced_hashes?),
      [:number, "2"],
      [:close_hash, "}"],
    ].compact
  end

  please do check({:"simplekey" => :value})
    if symbol_hash_keys?
      tokens.should == [
        [:open_hash, "{"],
        [:symbol, "simplekey"],
        [:symbol_prefix, ":"],
        [:whitespace, " "],
        [:symbol_prefix, ":"],
        [:symbol, "value"],
        [:close_hash, "}"],
      ]
    else
      tokens.should == [
        [:open_hash, "{"],
        [:symbol_prefix, ":"],
        [:symbol, "simplekey"],
        [:refers, "=>"],
        [:symbol_prefix, ":"],
        [:symbol, "value"],
        [:close_hash, "}"],
      ]
    end
  end

  please do check({:"string key" => :value})
    if symbol_hash_keys?
      tokens.should == [
        [:open_hash, "{"],
        [:open_symbol_string, "\""],
        [:symbol_string, "string key"],
        [:close_symbol_string, "\""],
        [:symbol_prefix, ":"],
        [:whitespace, " "],
        [:symbol_prefix, ":"],
        [:symbol, "value"],
        [:close_hash, "}"],
      ]
    else
      tokens.should == [
        [:open_hash, "{"],
        [:symbol_prefix, ":"],
        [:open_symbol_string, "\""],
        [:symbol_string, "string key"],
        [:close_symbol_string, "\""],
        [:refers, "=>"],
        [:symbol_prefix, ":"],
        [:symbol, "value"],
        [:close_hash, "}"],
      ]
    end
  end

  please do check({:hallo => {1=>Set[2,3,4]}})
    if symbol_hash_keys?
      fail
      tokens.should == [
        # TODO
      ]
    else
      tokens.should be_like [
        [:open_hash, "{"],
        [:symbol_prefix, ":"],
        [:symbol, "hallo"],
        [:refers, "=>"],
        [:open_hash, "{"],
        [:number, "1"],
        ([:whitespace, " "] if spaced_hashes?),
        [:refers, "=>"],
        ([:whitespace, " "] if spaced_hashes?),
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
      *([[:whitespace, " "]] * (spaced_hashes? ? 8 : 2))
    ]
  end
end
