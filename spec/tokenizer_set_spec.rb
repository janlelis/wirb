require 'set'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check Set[2,3,4]
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
     ]
   end
end
