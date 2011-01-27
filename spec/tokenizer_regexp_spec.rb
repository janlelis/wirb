describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check /music/
    tokens.should == [[:open_regexp, "/"], [:regexp, "music"], [:close_regexp, "/"]]
  end

  please do check /music/mix
    tokens.should == [[:open_regexp, "/"], [:regexp, "music"], [:close_regexp, "/"], [:regexp_flags, "mix"]]
  end

  please do check /mus\/ic/
    tokens.should == [[:open_regexp, "/"], [:regexp, "mus\\/ic"], [:close_regexp, "/"]]
  end

  please do check /\b([A-Z0-9._%+-]+)@([A-Z0-9.-]+\.[A-Z]{2,4})\b/i
    tokens.should == [
      [:open_regexp, "/"],
      [:regexp, "\\b([A-Z0-9._%+-]+)@([A-Z0-9.-]+\\.[A-Z]{2,4})\\b"],
      [:close_regexp, "/"],
      [:regexp_flags, "i"],
    ]
  end
end
