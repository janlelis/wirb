describe tokenizer(__FILE__) do
  after :each do check_value end

  please do check_inspected "> 3.0.0.beta.4"
    tokens.should == [
      [:gem_requirement, "> 3.0.0.beta.4"],
    ]
  end

  please do
    require 'rspec'
    check [Gem::Specification.find_by_name('rspec').dependencies.first.requirement]*2
    tokens.should == [
      [:open_array, '['],
      [:gem_requirement, "~> #{ RSpec::Version::STRING}"],
      [:comma, ","],
      [:whitespace, " "],
      [:gem_requirement, "~> #{ RSpec::Version::STRING}"],
      [:close_array, ']'],
    ]
  end

  please do check_inspected "{1=>>= 0}"
    tokens.should == [
      [:open_hash, '{'],
      [:number, '1'],
      [:refers, '=>'],
      [:gem_requirement, ">= 0"],
      [:close_hash, '}'],
    ]
  end

  please do check Gem::Specification.find_by_name('wirb').dependencies.first
    tokens.should == [ # <Gem::Dependency type=:development name="rspec" requirements=">= 0">
      [:open_object, "<"],
      [:object_class, "Gem"],
      [:class_separator, "::"],
      [:object_class, "Dependency"],
      [:object_description_prefix, " "],
      [:object_description, "type=:development name="],
      [:open_string, "\""],
      [:string, "rspec"],
      [:close_string, "\""],
      [:object_description, " requirements="],
      [:open_string, "\""],
      [:string, ">= 0"],
      [:close_string, "\""],
      [:close_object, ">"],
    ]
  end
end