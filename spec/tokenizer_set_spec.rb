require 'set'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check Set[2,3,4]
    if concise_set?
      tokens.should be_like [
        [:class, "Set"],
        [:open_array, "["],
        [:number, "2"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "3"],
        [:comma, ","],
        [:whitespace, " "],
        [:number, "4"],
        [:close_array, "]"],
      ]
    else
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:whitespace, " "],
        [:open_set, "{"],
        [:number, /\d/],
        [:comma, ","],
        [:whitespace, " "],
        [:number, /\d/],
        [:comma, ","],
        [:whitespace, " "],
        [:number, /\d/],
        [:close_set, "}"],
        [:close_object, ">"],
      ]
    end
  end

  unless concise_set?
    please do check Set[[2,3], {1=>{2=>3}}]
      tokens.should be_sorted [
        [:close_array, "]"],
        [:close_hash, "}"],
        [:close_hash, "}"],
        [:close_object, ">"],
        [:close_set, "}"],
        [:comma, ","],
        [:comma, ","],
        [:number, "1"],
        [:number, "2"],
        [:number, "2"],
        [:number, "3"],
        [:number, "3"],
        [:object_class, "Set"],
        [:object_description_prefix, ":"],
        [:open_array, "["],
        [:open_hash, "{"],
        [:open_hash, "{"],
        [:open_object, "#<"],
        [:open_set, "{"],
        [:refers, "=>"],
        [:refers, "=>"],
        [:whitespace, " "],
        [:whitespace, " "],
        [:whitespace, " "],
        ([:whitespace, " "] if spaced_hashes?),
        ([:whitespace, " "] if spaced_hashes?),
        ([:whitespace, " "] if spaced_hashes?),
        ([:whitespace, " "] if spaced_hashes?),
      ].compact
    end
  end
end
