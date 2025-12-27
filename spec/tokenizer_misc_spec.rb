# encoding: US-ASCII

require 'stringio'
require 'date'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check StringIO.new 'wirb'
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "StringIO"],
      [:object_description_prefix, ":"],
      [:object_address, OBJECT_ID],
      [:close_object, ">"],
    ]
  end

  please do check Date.today
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Date"],
      [:object_description_prefix, ":"],
      [:object_description, /.*/],
      [:close_object, ">"],
    ]
  end

  please do check "communication".match /.*(.)\1.*/
    tokens.should == [
      [:open_object, "#<"],
      [:object_class, "MatchData"],
      [:object_description_prefix, " "],
      [:open_string, "\""],
      [:string, "communication"],
      [:close_string, "\""],
      [:object_description, " 1:"],
      [:open_string, "\""],
      [:string, "m"],
      [:close_string, "\""],
      [:close_object, ">"],
    ]
  end

  please do check __ENCODING__
    tokens.should == [
      [:open_object, "#<"],
      [:object_class, "Encoding"],
      [:object_description_prefix, ":"],
      [:object_description, "US-ASCII"],
      [:close_object, ">"],
    ]
  end
end
