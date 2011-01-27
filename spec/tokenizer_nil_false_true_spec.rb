describe 'Wirb.tokenize' do
  after :each do check_value end

  please do check true
    tokens.should == [[:true, "true"]]
  end

  please do check false
    tokens.should == [[:false, "false"]]
  end

  please do check nil
    tokens.should == [[:nil, "nil"]]
  end
end
