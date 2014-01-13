describe tokenizer(__FILE__) do
  after :each do check_value end

  unless RubyEngine.jruby?
    please do check_inspected "> 3.0.0.beta.4"
      tokens.should == [
        [:gem_requirement_condition, ">"],
        [:whitespace, " "],
        [:gem_requirement_version, "3.0.0.beta.4"],
      ]
    end

    please do check_inspected "< 3"
      tokens.should == [
        [:gem_requirement_condition, "<"],
        [:whitespace, " "],
        [:gem_requirement_version, "3"],
      ]
    end

    please do check_inspected "<= 3"
      tokens.should == [
        [:gem_requirement_condition, "<="],
        [:whitespace, " "],
        [:gem_requirement_version, "3"],
      ]
    end

    please do check_inspected "{1=>>= 0}"
      tokens.should == [
        [:open_hash, '{'],
        [:number, '1'],
        [:refers, '=>'],
        [:gem_requirement_condition, ">="],
        [:whitespace, " "],
        [:gem_requirement_version, "0"],
        [:close_hash, '}'],
      ]
    end

    if Gem::Specification.respond_to? :find_by_name
      only19 do
        please do
          require 'rspec'
          rspec_version = Gem::Specification.find_by_name('rspec').dependencies.first.requirement
          only_version_number = rspec_version.requirements[0][1].to_s
          check [rspec_version]*2
          tokens.should == [
            [:open_array, '['],
            [:gem_requirement_condition, "~>"],
            [:whitespace, " "],
            [:gem_requirement_version, only_version_number],
            [:comma, ","],
            [:whitespace, " "],
            [:gem_requirement_condition, "~>"],
            [:whitespace, " "],
            [:gem_requirement_version, only_version_number],
            [:close_array, ']'],
          ]
        end
      end

      please do
        check Gem::Specification.find_by_name('wirb').dependencies.first
        tokens.should == [ # <Gem::Dependency type=:development name="rspec" requirements=">= 0">
          [:open_object, "<"],
          [:object_class, "Gem"],
          [:class_separator, "::"],
          [:object_class, "Dependency"],
          [:object_description_prefix, " "],
          [:object_description, "type=:development name="],
          [:open_string, "\""],
          [:string, "paint"],
          [:close_string, "\""],
          [:object_description, " requirements="],
          [:open_string, "\""],
          [:string, "~> 0.8"],
          [:close_string, "\""],
          [:close_object, ">"],
        ]
      end
    end
  end
end
