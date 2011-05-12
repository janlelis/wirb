describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check "always, again."
    tokens.should == [[:open_string, '"'], [:string, "always, again."], [:close_string, '"']]
  end

  please do check '"quote"'
    tokens.should == [[:open_string, '"'], [:string, "\\\"quote\\\""], [:close_string, '"']]
  end

  please do check "\\"
    tokens.should == [
      [:open_string, "\""],
      [:string, "\\\\"],
      [:close_string, "\""],
    ]
  end

  please do check "\\\\"
    tokens.should == [
      [:open_string, "\""],
      [:string, "\\\\\\\\"],
      [:close_string, "\""],
    ]
  end

  please do check "\\\"X"
    tokens.should == [
      [:open_string, "\""],
      [:string, "\\\\\\\"X"],
      [:close_string, "\""],
    ]
  end
end
