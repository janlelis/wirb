describe tokenizer(__FILE__) do
  after :each do check_value end

  if !RubyEngine.rbx?
    please do check [2,3,4].each
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_array, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:object_description, ":each"],
        [:close_object, ">"],
      ]
    end

    please do check Set[2,3,4].map
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:object_description, RubyEngine.truffle? ? ":collect" : ":map"],
        [:close_object, ">"],
      ]
    end

    please do check({1=>3}.each)
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "3"],
        [:close_hash, "}"],
        [:object_description, ":each"],
        [:close_object, ">"],
      ]
    end

    please do check({1=>3}.each.map)
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "3"],
        [:close_hash, "}"],
        [:object_description, ":each"],
        [:close_object, ">"],
        [:object_description, RubyEngine.truffle? ? ":collect" : ":map"],
        [:close_object, ">"],
      ]
    end

    please do check [2,Set[{1=>2}],4].map
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_array, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "2"],
        [:close_hash, "}"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:object_description, ":map"],
        [:close_object, ">"],
      ]
    end

    please do check Wirb::Tokenizer.run('[2,3,4]')
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:class, "Wirb"],
        [:class_separator, "::"],
        [:class, "Tokenizer"],
        [:object_description, ":run("],
        [:open_string, "\""],
        [:string, "[2,3,4]"],
        [:close_string, "\""],
        [:object_description, ")"],
        [:close_object, ">"],
      ]
    end

    please do check [{1=>2},Wirb::Tokenizer.run('2'),Set[2,3],[3,4],[5,6].each].map
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_array, "["],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "2"],
        [:close_hash, "}"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:class, "Wirb"],
        [:class_separator, "::"],
        [:class, "Tokenizer"],
        [:object_description, ":run("],
        [:open_string, "\""],
        [:string, "2"],
        [:close_string, "\""],
        [:object_description, ")"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_array, "["],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_array, "["],
        [:number, "5"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "6"],
        [:close_array, "]"],
        [:object_description, ":each"],
        [:close_object, ">"],
        [:close_array, "]"],
        [:object_description, ":map"],
        [:close_object, ">"],
      ]
    end
  else # is rbx
    please do check [2,3,4].each
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "each"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_array, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check Set[2,3,4].map
      tokens.sort.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "collect"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check({1=>3}.each)
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "each"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "3"],
        [:close_hash, "}"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check({1=>3}.each.map)
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "collect"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "each"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "3"],
        [:close_hash, "}"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check [2,Set[{1=>2}],4].map
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "map"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_array, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "2"],
        [:close_hash, "}"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check Wirb::Tokenizer.run('[2,3,4]')
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "run"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:class, "Wirb"],
        [:class_separator, "::"],
        [:class, "Tokenizer"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:open_string, "\""],
        [:string, "[2,3,4]"],
        [:close_string, "\""],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end

    please do check [{1=>2},Wirb::Tokenizer.run('2'),Set[2,3],[3,4],[5,6].each].map
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "map"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_array, "["],
        [:open_hash, "{"],
        [:number, "1"],
        [:refers, "=>"],
        [:number, "2"],
        [:close_hash, "}"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "run"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:class, "Wirb"],
        [:class_separator, "::"],
        [:class, "Tokenizer"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:open_string, "\""],
        [:string, "2"],
        [:close_string, "\""],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:close_set, "}"],
        [:close_object, ">"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_array, "["],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
        [:comma, ","],
        [:whitespace, " "],
        [:open_object, "#<"],
        [:object_class, "Enumerable"],
        [:class_separator, "::"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_address, /#{OBJECT_ID}/],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "iter"],
        [:object_description, "="],
        [:symbol_prefix, ":"],
        [:symbol, "each"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "object"],
        [:object_description, "="],
        [:open_array, "["],
        [:number, "5"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "6"],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "generator"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lookahead"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "args"],
        [:object_description, "="],
        [:open_array, "["],
        [:close_array, "]"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "size"],
        [:object_description, "="],
        [:nil, "nil"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "feedvalue"],
        [:object_description, "="],
        [:nil, "nil"],
        [:close_object, ">"],
      ].sort
    end
  end
end
