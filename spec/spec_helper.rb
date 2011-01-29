require File.dirname(__FILE__) + '/../lib/wirb' unless defined? Wirb
require File.dirname(__FILE__) + '/../lib/wirb/wp'
require 'zucker/engine'
require 'zucker/version'

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

def only19
  yield if RubyVersion == 1.9
end

def only18
  yield if RubyVersion == 1.8
end

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

# common regex patterns
OBJECT_ID = /0x[0-9a-f]+/

=begin helper methods for getting tokens
def ws(obj)
  puts Wirb.tokenize(obj.inspect).map{|*x| x.inspect + ','}*$/
end
=end
