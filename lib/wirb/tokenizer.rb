class << Wirb
  # This is an extended version of the original wirble tokenizer.
  # Almost everyone would say that 300 lines long case statements need refactoring, but
  # ...sometimes it just doesn't matter ;)
  def tokenize(str)
    raise ArgumentError, 'Tokenizer needs an inspect-string' unless str.is_a? String
    return enum_for(:tokenize, str) unless block_given?

    chars = str.split(//)

    @state, @token, i  =  [], '', 0
    @passed, snapshot  =  '', nil # exception handling

    # helpers
    pass_custom_state = lambda{ |kind, *options|
      yield kind, @token  unless @token.empty?
      @passed << @token
      @state.pop          if     options.include?(:remove)
      @token  = ''        unless options.include?(:keep_token)
      @repeat = true      if     options.include?(:repeat)
    }

    pass_state  = lambda{ |*options| pass_custom_state[ @state[-1], *options ] }

    pass        = lambda{ |kind, string| @passed << string; yield kind, string }
    
    set_state   = lambda{ |state, *options|
      @state[-1] = state
      @repeat = true if options.include? :repeat
    }

    get_state   = lambda{ |state| @state[-1] == state }

    get_previous_state =
                  lambda{ |state| @state[-2] == state }

    push_state  = lambda{ |state, *options|
      @state << state
      @repeat = true if options.include? :repeat
    }

    pop_state   = lambda{ |*options|
      @state.pop
      @repeat = true if options.include? :repeat
    }

    # action!
    while i <= chars.size
      @repeat = false
      llc, lc, c, nc = lc, c, chars[i], chars[i+1]

      # warn "char = #{c}  state = #{@state*':'}"

      case @state[-1]
      when nil, :hash, :array, :enumerator, :set # "default" state
        case c
        when '"'      then push_state[:string]
        when '/'      then push_state[:regexp]
        when '#'      then push_state[:object]
        when /[A-Z]/  then push_state[:class,    :repeat]
        when /[a-z]/  then push_state[:keyword,  :repeat]
        when /[0-9-]/ then push_state[:number,   :repeat]
        when '.'      then push_state[:range,    :repeat]
        when /\s/     then pass[:whitespace, c]
        when ','      then pass[:comma, ',']

        when ':'
          if get_state[:enumerator]
            set_state[:object_description, :repeat]
          else
            push_state[:symbol]
          end
 
        when '>'
          if lc == '='
            if get_state[:hash]
              pass[:refers, '=>']
            else # FIXME remove this buggy <=> cheat
              pass[:symbol, '=>']
            end
          end
        when '('
          if nc =~ /[0-9-]/
            push_state[:rational, :repeat]
          else
            push_state[:object_description, :repeat]
            open_brackets = 0
          end
 
        when '{'
          if get_state[:set]
            pass[:open_set, '{']; push_state[nil] # {{ means set-hash
          else
            pass[:open_hash, '{']; push_state[:hash]
          end

        when '['
          pass[:open_array, '[']; push_state[:array]
          
        when ']'
          if get_state[:array]
            pass[:close_array, ']']
            pop_state[]
            pop_state[] if get_state[:enumerator]
          end

        when '}'
          if get_state[:hash]
            pass[:close_hash, '}']
          elsif get_previous_state[:set]
            pass[:close_set, '}']
            pop_state[] # remove extra nil state
          end
          pop_state[]
          pop_state[] if get_state[:enumerator]

        # else
        #   warn "ignoring char #{c.inspect}" if @debug
        end

      when :class
        next set_state[:time, :repeat] if c == ' ' # Ruby 1.8 default timestamp
        case c
        when /[a-z0-9_]/i
          @token << c
        else
          if c ==':' && nc == ':'
            pass_state[]
            pass[:class_separator, '::']
          elsif !(c == ':' && lc == ':')
            pass_state[:remove, :repeat]
          end
        end

      when :symbol
        case c
        when /"/
          pass[:symbol_prefix, ':']
          set_state[:symbol_string]
          @token = ''
        when /[^"., }\])=]/
          @token << c
        else
          if c == ']' && lc == '['
            @token << c
          elsif c == '=' && nc != '>' # FIXME: spaceship error
            @token << c
          else
            pass[:symbol_prefix, ':']
            pass_state[:remove, :repeat]
          end
        end

      when :symbol_string
        if c == '"' && ( !( @token =~ /\\+$/; $& ) || $&.size % 2 == 0 ) # see string
          pass[:open_symbol_string, '"']
          pass_state[:remove]
          pop_state[]
          pass[:close_symbol_string, '"']
        else
          @token << c
        end

      when :string
        if c == '"' && ( !( @token =~ /\\+$/; $& ) || $&.size % 2 == 0 ) # allow escaping of " and
          pass[:open_string, '"']                                        # work around \\
          pass_state[:remove]
          pass[:close_string, '"']
        else
          @token << c
        end

      when :regexp
        if c == '/' && ( !( @token =~ /\\+$/; $& ) || $&.size % 2 == 0 ) # see string
          pass[:open_regexp, '/']
          pass_state[:remove]
          pass[:close_regexp, '/']
          push_state[:regexp_flags]
        else
          @token << c
        end

      when :regexp_flags
        if c =~ /[a-z]/i #*%w[m i x o n e u s]
          @token << c
        else
          pass_state[:remove, :repeat]
        end

      when :keyword
        if c =~ /[a-z0-9_]/i
          @token << c
          pass_custom_state[@token.to_sym, :remove] if %w[nil false true].include?(@token)
        else
          pass_state[:remove, :repeat]
        end

      when :number
        if c == '-' && @token != '' && @token[-1] != 'e'
          set_state[:time, :repeat]
        elsif c =~ /[0-9e+.-]/ && !(c == '.' && nc == '.')
          @token << c
        elsif c == '/' # ruby 1.8 mathn
          pass_state[]
          pass[:rational_separator, '/']
        else
          pass_state[:remove, :repeat]
        end

      when :time # via regex, state needs to be triggered somewhere else
        peek = chars[i..-1].join
        if [
          /^\d+-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (?:[+-]\d{4}|[a-z]{3})/i,               # 1.9 / UTC
          /^[a-z]{3} [a-z]{3} \d{2} \d{2}:\d{2}:\d{2} (?:[+-]\d{4}|[a-z]{3}) \d{4}/i, # 1.8
          #/^\d+-\d{2}-\d{2}/, # simple date
        ].any?{ |regex|
          ( @token + peek ) =~ regex
        } # found, adjust parsing-pointer:
          i = i + $&.size - @token.size - 1
          @token = $&
          pass_state[:remove]
        else
          @token << c
          pop_state[:remove]
        end
 
      when :range
        if c == '.'
          @token << c
        else
          pass_state[:remove, :repeat]
        end

      when :rational
        case c
        when '('
          pass[:open_rational, '(']
        when /[0-9-]/
          push_state[:number, :repeat]
        when '/', ','
          pass[:rational_separator, c]
        when ' '
          pass[:whitespace, c]
        when ')'
          pass[:close_rational, ')']
          pop_state[]
        end

      when :object
        case c
        when '<'
          pass[:open_object, '#<']
          push_state[:object_class]
          open_brackets = 0
        when '>'
          pass[:close_object, '>']
          pop_state[]
          pop_state[] if get_state[:enumerator]
        end

      when :object_class
        case c
        when /[a-z0-9_]/i
          @token << c
        when '>'
          pass_state[:remove, :repeat]
        else
          if c == ':' && nc == ':'
            pass_state[]
            pass[:class_separator, '::']
          elsif !(c == ':' && lc == ':')
            pass_state[:keep_token]
            pass[:object_description_prefix, c]

            @token = @token.downcase
            if %w[set].include? @token
              set_state[@token.to_sym]
            else
              set_state[:object_description]
              if %w[enumerator].include? @token
                push_state[@token.to_sym]
              end
            end
            @token = ''
          end
        end

      when :object_description
        case c
        when '>', nil
          if open_brackets == 0
            pass_state[:remove, :repeat]
          else
            open_brackets -= 1
            @token << c
          end
        when '<'
          open_brackets += 1
          @token << c
        when '"'
          pass_state[]
          push_state[:string]
        when /[0-9]/
          if c == '0' && nc == 'x'
            pass_state[:repeat]
            push_state[:object_addr]
          else
            # push_state[:number, :repeat]
            @token << c
          end
        else
          @token << c
        end

      when :object_addr
        if c =~ /[x0-9a-f]/
          @token << c
        else
          if c == '@'
            pass_state[:remove]
            push_state[:object_line]
            pass[:object_line_prefix, '@']
          else
            pass_state[:remove, :repeat]
          end
        end

       when :object_line
        if c == ':' && nc =~ /[0-9]/
          @token << ':'
          pass_state[:remove]
          push_state[:object_line_number]
        else
          @token << c
        end

      when :object_line_number
        if c =~ /[0-9]/
          @token << c
        else
          pass_state[:remove, :repeat]
        end
      
      # else
      #   raise "unknown state #{@state[-1]} #{@state.inspect}"
      end

      # next round :)
      if !@repeat
        i += 1
      elsif snapshot && Marshal.load(snapshot) == [@state, @token, llc, lc, c, nc] # loop protection
        raise 'Wirb Bug :/'
      end

      snapshot = Marshal.dump([@state, @token, llc, lc, c, nc])
    end
  rescue
     p$!, $!.backtrace[0]
    pass[:default, str.sub(@passed, '')]
  end
end

# J-_-L
