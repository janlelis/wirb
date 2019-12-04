describe tokenizer(__FILE__) do
  after :each do check_value end


  please do
    now = Time.now
    now2 = Time.now
    check [now, now2]
    tokens.should == [
      [:open_array, "["],
      [:time, now.inspect],
      [:comma, ","],
      [:whitespace, " "],
      [:time, now2.inspect],
      [:close_array, "]"],
    ]
  end
end
