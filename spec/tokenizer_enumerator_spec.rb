describe tokenizer(__FILE__) do
  after :each do check_value end

  only19 do
    please do check [2,3,4].each
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_description, " "],
        [:open_enumerator, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_enumerator, "]"],
        [:object_description, ":each"],
        [:close_object, ">"],
      ]
    end

    please do check [2,Set[{1=>2}],4].map
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_description, " "],
        [:open_enumerator, "["],
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
        [:close_enumerator, "]"],
        [:object_description, ":map"],
        [:close_object, ">"],
      ]
    end

    please do check Wirb.tokenize('[2,3,4]')
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_description, " Wirb:tokenize("],
        [:open_string, "\""],
        [:string, "[2,3,4]"],
        [:close_string, "\""],
        [:object_description, ")"],
        [:close_object, ">"],
      ]
    end

    require 'prime'
    please do check Prime.each
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Prime"],
        [:class_separator, "::"],
        [:object_class, "EratosthenesGenerator"],
        [:object_description_prefix, ":"],
        [:object_addr, /#{OBJECT_ID}/],
        [:object_description, ' @last_prime=nil, @ubound=nil'],
        [:close_object, ">"],
      ]
    end

    please do check [{1=>2},Wirb.tokenize('2'),Set[2,3],[3,4],[5,6].each].map
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "Enumerator"],
        [:object_description_prefix, ":"],
        [:object_description, " "],
        [:open_enumerator, "["],
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
        [:object_description, " Wirb:tokenize("],
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
        [:object_description, " "],
        [:open_enumerator, "["],
        [:number, "5"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "6"],
        [:close_enumerator, "]"],
        [:object_description, ":each"],
        [:close_object, ">"],
        [:close_enumerator, "]"],
        [:object_description, ":map"],
        [:close_object, ">"],
      ]
    end
  end
end
