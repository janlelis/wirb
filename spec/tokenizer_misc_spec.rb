# encoding: US-ASCII

require 'stringio'
require 'date'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check StringIO.new 'wirb'
    if RubyEngine.rbx?
      tokens.sort.should be_like [
        [:open_object, "#<"],
        [:object_class, "StringIO"],
        [:object_description_prefix, ":"],
        [:object_address, OBJECT_ID],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "append"],
        [:object_description, "="],
        [:false, "false"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "readable"],
        [:object_description, "="],
        [:true, "true"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "writable"],
        [:object_description, "="],
        [:true, "true"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "__data__"],
        [:object_description, "="],
        [:open_object, "#<"],
        [:object_class, "StringIO"],
        [:class_separator, "::"],
        [:object_class, "Data"],
        [:object_description_prefix, ":"],
        [:object_address, OBJECT_ID],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "encoding"],
        [:object_description, "="],
        [:open_object, "#<"],
        [:object_class, "Encoding"],
        [:object_description_prefix, ":"],
        [:object_description, "US-ASCII"],
        [:close_object, ">"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "lineno"],
        [:object_description, "="],
        [:number, "0"],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "string"],
        [:object_description, "="],
        [:open_string, "\""],
        [:string, "wirb"],
        [:close_string, "\""],
        [:object_description, " "],
        [:object_variable_prefix, "@"],
        [:object_variable, "pos"],
        [:object_description, "="],
        [:number, "0"],
        [:close_object, ">"],
        [:close_object, ">"],
      ].sort
   else
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "StringIO"],
        [:object_description_prefix, ":"],
        [:object_address, OBJECT_ID],
        [:close_object, ">"],
      ]
    end
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
