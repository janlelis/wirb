require 'complex'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check 42
    tokens.should == [[:number, "42"]]
  end

  please do check [1..2, 3...4, 'a'..'z', 'a'...'z']
    tokens.should == [
      [:open_array, "["],
      [:number, "1"],
      [:range, ".."],
      [:number, "2"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "3"],
      [:range, "..."],
      [:number, "4"],
      [:comma, ","],
      [:whitespace, " "],
      [:open_string, "\""],
      [:string, "a"],
      [:close_string, "\""],
      [:range, ".."],
      [:open_string, "\""],
      [:string, "z"],
      [:close_string, "\""],
      [:comma, ","],
      [:whitespace, " "],
      [:open_string, "\""],
      [:string, "a"],
      [:close_string, "\""],
      [:range, "..."],
      [:open_string, "\""],
      [:string, "z"],
      [:close_string, "\""],
      [:close_array, "]"],
    ]
  end

  please do check [2, 3, 4.0, -3, 99e99, 1e-99, 2_3_4, 4E8]
    tokens.should == [
      [:open_array, "["],
      [:number, "2"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "3"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "4.0"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "-3"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "9.9e+100"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "1.0e-99"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "234"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "400000000.0"],
      [:close_array, "]"],
    ]
  end

  please do check Rational(2,3)
    tokens.should == [
      [:open_rational, "("],
      [:number, "2"],
      [:rational_separator, "/"],
      [:number, "3"],
      [:close_rational, ")"],
    ]
  end

=begin
  only18 do
    please do check Rational(2,3)
      tokens.should == [
        [:class, "Rational"],
        [:open_rational, "("],
        [:number, "2"],
        [:rational_separator, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:close_rational, ")"],
      ]

      # modifying the world, see https://github.com/janlelis/wirb/issues#issue/1
      require 'mathn'
      check Rational(2,3)
      tokens.should == [
        [:number, "2"],
        [:rational_separator, "/"],
        [:number, "3"],
      ]
    end
  end
=end

  please do check (1/0.0)
    tokens.should == [
      [:special_number, "Infinity"],
    ]
  end

  please do check [-(1/0.0), (0/0.0), -(1/0.0), -(0/0.0)]
    tokens.should == [
      [:open_array, "["],
      [:special_number, "-Infinity"],
      [:comma, ","],
      [:whitespace, " "],
      [:special_number, "NaN"],
      [:comma, ","],
      [:whitespace, " "],
      [:special_number, "-Infinity"],
      [:comma, ","],
      [:whitespace, " "],
      [:special_number, "NaN"],
      [:close_array, "]"],
    ]
  end

  please do check Complex(-2.2,-3.3)
    tokens.should == [
      [:open_complex, "("],
      [:number, "-2.2-3.3i"],
      [:close_complex, ")"],
    ]
  end

  please do check Complex(-1/0.0, 0/0.0)
    tokens.should == [
      [:open_complex, "("],
      [:special_number, "-Infinity"],
      [:special_number, "+NaN"],
      [:number, '*i'],
      [:close_complex, ")"],
    ]
  end
end

=begin
  only18 do
    please do check Complex(-2.2,-3.3)
      tokens.should == [
        [:class, "Complex"],
        [:open_complex, "("],
        [:number, "-2.2"],
        [:number, ","],
        [:whitespace, " "],
        [:number, "-3.3"],
        [:close_complex, ")"],
      ]
    end
  end
end
=end
