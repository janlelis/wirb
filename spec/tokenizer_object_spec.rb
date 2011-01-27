require 'ostruct'

describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check Object.new
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Object"],
      [:object_description_prefix, ":"],
      [:object_addr, OBJECT_ID],
      [:close_object, ">"],
    ]
 end

  please do check proc{}
    tokens.should be_like [
      [:open_object, "#<"],
      [:object_class, "Proc"],
      [:object_description_prefix, ":"],
      [:object_addr, OBJECT_ID],
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
      [:object_addr, OBJECT_ID],
      [:object_line_prefix, "@"],
      [:object_line, /.*tokenizer_object_spec.rb:/],
      [:object_line_number, /\d+/],
      RubyVersion == 1.9 ? [:object_description, " (lambda)"] : nil,
      [:close_object, ">"],
    ].compact
  end

  unless RubyEngine.rbx? # rubinius provides more information
    please do check binding
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Binding"],
        [:object_description_prefix, ":"],
        [:object_addr, OBJECT_ID],
        [:close_object, ">"],
      ]
    end
  end

  only19 do
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
     
    please do check Module.new.singleton_class.singleton_class
      tokens.should be_like [
        [:open_object, "#<"],
        [:object_class, "Class"],
        [:object_description_prefix, ":"],
        [:object_description, '#<Class:#<Module:'],
        [:object_addr, OBJECT_ID],
        [:object_description, '>>'],
        [:close_object, ">"]
      ]
    end
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
end
