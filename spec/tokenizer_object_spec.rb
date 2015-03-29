require 'ostruct'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check Object.new
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Object"],
      [:object_description_prefix, ":"],
      [:object_address, OBJECT_ID],
      [:close_object, ">"],
    ]
 end

  please do check proc{}
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Proc"],
      [:object_description_prefix, ":"],
      [:object_address, OBJECT_ID],
      [:object_line_prefix, "@"],
      [:object_line, /.*tokenizer_object_spec.rb:/],
      [:object_line_number, /\d+/],
      [:close_object, ">"],
    ]
  end

  please do check lambda{}
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Proc"],
      [:object_description_prefix, ":"],
      [:object_address, OBJECT_ID],
      [:object_line_prefix, "@"],
      [:object_line, /.*tokenizer_object_spec.rb:/],
      [:object_line_number, /\d+/],
      [:object_description, " (lambda)"],
      [:close_object, ">"],
    ]
  end

  please do check StringScanner.new('wirb')
    tokens.should == [
      [:open_object, "#<"],
      [:object_class, "StringScanner"],
      [:object_description_prefix, " "],
      [:object_description, "0/4 @ "],
      [:open_string, "\""],
      [:string, "wirb"],
      [:close_string, "\""],
      [:close_object, ">"],
    ]
  end

  unless RubyEngine.rbx? # rubinius provides more information
    please do check binding
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Binding"],
        [:object_description_prefix, ":"],
        [:object_address, OBJECT_ID],
        [:close_object, ">"],
      ]
    end
  end

  if RubyEngine.rbx?
    please do check STDOUT
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "IO"],
        [:object_description_prefix, ":"],
        [:object_description, "fd 1"],
        [:close_object, ">"],
      ]
    end

    please do check STDIN
       tokens.should == [
        [:open_object, "#<"],
        [:object_class, "IO"],
        [:object_description_prefix, ":"],
        [:object_description, "fd 0"],
        [:close_object, ">"],
      ]
    end
  else
    please do check STDOUT
      tokens.should == [
        [:open_object, "#<"],
        [:object_class, "IO"],
        [:object_description_prefix, ":"],
        [:object_description, "<STDOUT>"],
        [:close_object, ">"],
      ]
    end

    please do check STDIN
       tokens.should == [
        [:open_object, "#<"],
        [:object_class, "IO"],
        [:object_description_prefix, ":"],
        [:object_description, "<STDIN>"],
        [:close_object, ">"],
      ]
    end
  end

  please do check Module.new.singleton_class.singleton_class
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Class"],
      [:object_description_prefix, ":"],
      [:open_object, "#<"],
      [:object_class, "Class"],
      [:object_description_prefix, ":"],
      [:open_object, "#<"],
      [:object_class, "Module"],
      [:object_description_prefix, ":"],
      [:object_address, OBJECT_ID],
      [:close_object, ">"],
      [:close_object, ">"],
      [:close_object, ">"],
    ]
  end

  please do
    SomeStruct=Struct.new :favourite, :language
    check SomeStruct.new :ruby
    tokens.should == [
      [:open_object, "#<"],
      [:object_class, "struct"],
      [:object_description_prefix, " "],
      [:object_description, "SomeStruct favourite=:ruby, language=nil"],
      [:close_object, ">"],
    ]
  end

  please do check OpenStruct.new
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "OpenStruct"],
      [:close_object, ">"],
    ]
  end

  please do
    object = Object.new
    object.instance_variable_set(:@_, 42)
    check(object)
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Object"],
      [:object_description_prefix, ":"],
      [:object_address, /#{OBJECT_ID}/],
      [:object_description, " "],
      [:object_variable_prefix, "@"],
      [:object_variable, "_"],
      [:object_description, "="],
      [:number, "42"],
      [:close_object, ">"],
    ]
  end

  please do
    class Hey
      def initialize
        @hallo = [1,42]
      end
    end
    check Hey.new
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Hey"],
      [:object_description_prefix, ":"],
      [:object_address, /#{OBJECT_ID}/],
      [:object_description, " "],
      [:object_variable_prefix, "@"],
      [:object_variable, "hallo"],
      [:object_description, "="],
      [:open_array, "["],
      [:number, "1"],
      [:comma, ","],
      [:whitespace, " "],
      [:number, "42"],
      [:close_array, "]"],
      [:close_object, ">"]
    ]
  end
end
