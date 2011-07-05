require 'wirb'
require 'wirb/wp'
require 'zucker/engine'
require 'zucker/version'

Wirb.start

# TOKENIZER

def tokenizer(filename)
  filename =~ /tokenizer_(.*)_spec\.rb/
  "Wirb.tokenize" + ($1 ? "(#{$1})" : "")
end

def check_value
  Wirb.tokenize(@a).map{|_,c|c}.join.should == @a
end

def please(*args, &block)
  it *args, &block
end

def check(obj)
  @a = obj.inspect
  wp obj
end

def check_inspected(str)
  @a = str
  puts Wirb.colorize_result str
end

def tokens
  Wirb.tokenize(@a).to_a
end

# COLORIZER

shared_examples_for "a Wirb0 colorizer" do
  it "creates good color codes based on original Wirb color symbols" do
    # Wirb.get_color(:black).should match_colors(30)
    Wirb.get_color(:light_purple).should match_colors(1,35)
    Wirb.get_color(:brown_underline).should match_colors(4,33)
    Wirb.get_color(:green_background).should match_colors(42)
  end
  
  it "colorizes strings based on original Wirb color symbols" do
    Wirb.colorize_string('Mos Eisley', :blue).should match_colored_string('Mos Eisley', 34)
    Wirb.colorize_string('Tatooine', :light_red).should match_colored_string('Tatooine', 1, 31)
    Wirb.colorize_string('Bespin', :white).should match_colored_string('Bespin', 1, 37)
    Wirb.colorize_string('Coruscant', :cyan_underline).should match_colored_string('Coruscant', 4, 36)
  end
end

def extract_color_codes(string)
  res = string.scan(/\e\[(?:\d+(?:;\d+)*)?m/).map do |code_match|
    codes = []
    code_match.scan(/((?:38|48);5;\d+)|((\d+);(\d+))|(\d+)|^$/) do |code_parts|
      rgb_code, color_with_style, style, color, color_with_no_style = code_parts
      codes << if rgb_code
        rgb_code
      elsif color_with_style
        case style
        when '0'
          color
        when '7'
          (color.to_i+10).to_s
        else
          [style,color]
        end
      elsif color_with_no_style
        color_with_no_style
      else
        '0'
      end
    end
    codes
  end.flatten
  standardize_color_codes(res)
end

def standardize_color_codes(codes)
  codes = codes.map{|code| code.to_s}
  codes = codes.sort.uniq                               # Order of codes doesn't matter, nor does repetition
  if codes != ['0']
    codes -= ['0']                                      # Code '0' doesn't matter, unless it's the only one
  end
  codes
end

# MATCHER

# match regex in arrays (e.g. for  object ids)
RSpec::Matchers.define :be_like do |should_array|
  match do |got_array|
    if got_array.size != should_array.size
      false
    else
      got_array.zip(should_array).all? do |(plain_kind, plain_string),(regex_kind, regex_string)|
        regex_kind   ==  plain_kind &&
        regex_string === plain_string
      end
    end
  end
end

RSpec::Matchers.define :be_sorted do |should_array|
  match do |got_array|
    should_array = should_array.sort_by {|x,y|[x.to_s,y]}
    got_array    = got_array.sort_by    {|x,y|[x.to_s,y]}
    should_array == got_array
  end
end

RSpec::Matchers.define :be_sorted_like do |should_array|
  match do |got_array|
    should_array = should_array.sort_by {|x,y|[x.to_s,y]}
    got_array    = got_array.sort_by    {|x,y|[x.to_s,y]}
    if got_array.size != should_array.size
      false
    else
      got_array.zip(should_array).all? do
          |(plain_kind, plain_string),(regex_kind, regex_string)|
        regex_kind   ==  plain_kind &&
        regex_string === plain_string
      end
    end
  end
end

# Match the color codes from a string with an array of codes, e.g.
#  "\e\[1m\e\[34m".should match_colors(1,34)
# Order of the codes does not matter, and repeated codes are ignored
# Codes like "\e[0;32" are equivalent to "\e[0m\e[32m"
# Codes like 0,34 and 34 are equivalent
# Codes like 7,34 and 44 are equivalent
RSpec::Matchers.define :match_colors do |*should_codes|
  match do |got_string|
    got_codes = extract_color_codes(got_string)
    should_codes = standardize_color_codes(should_codes.flatten)
    
    should_codes == got_codes
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would match the color codes #{should_codes.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would match the color codes #{should_codes.inspect}"
  end
  
end

# Match an encoded string:
# Usage "\e[4m\e[33mStuff\e[0m".should match_colored_string('Stuff', 4, 33)
RSpec::Matchers.define :match_colored_string do |*should_spec|
  match do |got_string|
    should_string = should_spec.first
    should_codes = should_spec[1..-1]
    
    if matches=(got_string=~/^((?:\e\[\d+(?:;\d+)*m)+)(.*)(\e\[\d+(;\d+)*m)$/)
      got_codes  = $1
      got_string = $2
      got_terminating_code = $3
    end
    
    
    matches && 
    should_string == got_string && 
    got_codes.should(match_colors(should_codes)) && 
    got_terminating_code.should(match_colors(0))
  end

  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would match the string #{should_spec.first.inspect}, colored with color codes #{should_spec[1..-1].inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would not match the string #{should_spec.first}, colored with color codes #{should_spec[1..-1].inspect}"
  end
end

# GENERAL

def only19
  yield if RubyVersion == 1.9
end

def only18
  yield if RubyVersion == 1.8
end

# common regex patterns
OBJECT_ID = /0x[0-9a-f]+/

=begin helper method for getting tokens
def ws(obj); puts Wirb.tokenize(obj.inspect).map{|*x| x.inspect + ','}*$/; end
=end
