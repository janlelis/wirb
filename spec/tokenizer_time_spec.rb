describe tokenizer(__FILE__) do
  after :each do check_value end

  please do now = Time.now
            check [Time.now, Time.now]
    tokens.should == [
      [:open_array, "["],
      [:time, now.to_s],
      [:comma, ","],
      [:whitespace, " "],
      [:time, now.to_s],
      [:close_array, "]"],
    ]
  end
end
