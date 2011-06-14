describe tokenizer(__FILE__) do
  after :each do check_value end
  please do
    check_inspected "<RubyVM::InstructionSequence:pp"\
                    "@/home/jan/.rvm/rubies/ruby-1.9.2-p180"\
                    "/lib/ruby/1.9.1/irb/output-method.rb>"
    tokens.should == [
      [:open_object, "<"],
      [:object_class, "RubyVM"],
      [:class_separator, "::"],
      [:object_class, "InstructionSequence"],
      [:object_description_prefix, ":"],
      [:object_line_prefix, "pp@"],
      [:object_line, "/home/jan/.rvm/rubies/ruby-1.9.2-p180/lib/ruby/1.9.1/irb/output-method.rb"],
      [:close_object, ">"],
    ]
  end
end
