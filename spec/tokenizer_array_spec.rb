describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check [1,2,3,4]
    tokens.should == [
      [:open_array, "["],
      [:number, "1"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "2"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "3"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "4"],
      [:close_array, "]"]
    ]
  end

  please do check [[[]]]
    tokens.should == [
      [:open_array, "["],
      [:open_array, "["],
      [:open_array, "["],
      [:close_array, "]"],
      [:close_array, "]"],
      [:close_array, "]"],
    ]
  end
end
