# only very basic support so far.. open issues ;)

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check_inspected "User(Table doesn't exist)"
    tokens.should == [
      [:class, "User"],
      [:object_description, "(Table doesn't exist)"],
    ]
  end
 
  please do check_inspected "User(id: integer, name: string, created_at: datetime, updated_at: datetime)"
    tokens.should == [
      [:class, "User"],
      [:object_description, "(id: integer, name: string, created_at: datetime, updated_at: datetime)"],
    ]
  end
end
