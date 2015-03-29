module Wirb
  module Tokenizer
    def self.run(str)
      return [] if str.nil?
      raise ArgumentError, 'Tokenizer needs an inspect-string' unless str.is_a? String
      return enum_for(:run, str) unless block_given?

      chars = str.split('')

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

      pass_state  = lambda{ |*options|
        pass_custom_state[ @state[-1], *options ]
      }

      pass        = lambda{ |kind, string|
        @passed << string
        yield kind, string
      }

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
        when nil, :hash, :array, :enumerator, :set, :variable # default state
          case c
          when '"'      then push_state[:string]
          when '/'      then push_state[:regexp]
          when '#'      then push_state[:object]
          when /[A-Z]/  then push_state[:class,    :repeat]
          when /[a-z]/  then push_state[:word,     :repeat]
          when /[0-9-]/ then push_state[:number,   :repeat]
          when '.'      then push_state[:range,    :repeat]
          when /\=/     then push_state[:equal,    :repeat]

          when /\s/
            if get_state[:variable]
              pop_state[:repeat]
            else
              pass[:whitespace, c]
            end

          when ','
            if get_state[:variable]
              pop_state[:repeat]
            else
              pass[:comma, ',']
              @refers_seen[-1] = false if get_state[:hash]
            end

          when ':'
            if get_state[:enumerator]
              set_state[:object_description, :repeat]
            else
              push_state[:symbol]
            end

          when '>'
            pop_state[:repeat]
          when '('
            peek = chars[i+1..-1].join
            if peek =~ /^-?(?:Infinity|NaN|[0-9.e]+)[+-](?:Infinity|NaN|[0-9.e]+)\*?i\)/
              push_state[:complex, :repeat]
            elsif nc =~ /[0-9-]/
              if @passed =~ /Complex$/ # cheat for old 1.8
                push_state[:complex, :repeat]
              else
                push_state[:rational, :repeat]
              end
            else
              push_state[:object_description, :repeat]
              open_brackets = 0
            end

          when '{'
            if get_state[:set]
              pass[:open_set, '{']; push_state[nil] # {{ means set-hash
            else
              pass[:open_hash, '{']; push_state[:hash]
              @refers_seen ||= []
              @refers_seen.push false
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
              @refers_seen.pop
            elsif get_previous_state[:set]
              pass[:close_set, '}']
              pop_state[] # remove extra nil state
            end
            pop_state[]
            pop_state[] if get_state[:enumerator]

          when '<'
            pass[:open_object, '<']
            push_state[:object]
            push_state[:object_class]
            open_brackets = 0
          end

        when :class
          case c
          when /[a-z0-9_]/i
            @token << c
          else
            if @token =~ /^(Infinity|NaN)$/
              set_state[:special_number, :repeat]
            elsif c ==':' && nc == ':'
              pass_state[]
              pass[:class_separator, '::']
            elsif !(c == ':' && lc == ':')
              pass_state[:remove, :repeat]
            end
          end

        when :symbol
          case c
          when /"/
            if lc == '$' && llc == ':'
              @token << c
            else
              pass[:symbol_prefix, ':']
              set_state[:symbol_string]
            end
          when /[^"., }\])=]/
            @token << c
          else
            if c == ']' && lc == '['
              @token << c
            elsif c == '=' && nc != '>'
              @token << c
            elsif c =~ /[.,]/ && lc == '$' && llc == ':'
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
            pass[:close_symbol_string, '"']
          else
            @token << c
          end

        when :string
          if c == '"' && ( !( @token =~ /\\+$/; $& ) || $&.size % 2 == 0 ) # allow escaping of " and
            pass[:open_string, '"']                              # work around \\
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

        when :word
          if c =~ /[a-z0-9_]/i
            @token << c
            pass_custom_state[@token.to_sym, :remove] if %w[nil false true].include?(@token)
          else
            pass_state[:remove, :repeat]
          end

        when :number
          if c == '-' && @token != '' && @token[-1] != 'e'
            set_state[:time, :repeat]
          elsif c =~ /[IN]/
            set_state[:special_number, :repeat]
          elsif c =~ /[0-9e.*i+-]/ && !(c == '.' && nc == '.')
            @token << c
          else
            pass_state[:remove, :repeat]
          end

        when :time # via regex, state needs to be triggered somewhere else
          peek = chars[i..-1].join
          if [
            /^\d+-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (?:[+-]\d{4}|[a-z]{3})/i,               # 1.9 / UTC
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

        when :special_number # like time, refactor if code is needed a third time
          peek = chars[i..-1].join
          if [
            /^[-+]?Infinity/,
            /^[-+]?NaN/,
          ].any?{ |regex|
            ( @token + peek ) =~ regex
          } # found, adjust parsing-pointer:
            i = i + $&.size - @token.size - 1
            @token = $&
            pass_state[]
            set_state[:number]
          else
            # TODO verify...
            @token << c
            set_state[:number]
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

        when :complex
          case c
          when '('
            pass[:open_complex, '(']
          when /[0-9+-]/
            push_state[:number, :repeat]
          when ','
            pass[:number, c] # complex_separator
          when ' '
            pass[:whitespace, c]
          when ')'
            pass[:close_complex, ')']
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
            elsif c != ':' || lc != ':'
              pass_state[:keep_token]
              pass[:object_description_prefix, c]

              @token = @token.downcase
              if %w[set instructionsequence].include?(@token)
                set_state[@token.to_sym]
              else
                set_state[:object_description]
                if @token == "enumerator" && RUBY_ENGINE != "rbx"
                  push_state[:enumerator]
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
          when '#'
            if nc == '<'
              pass_state[]
              push_state[:object]
            else
              @token << c
            end
          when '<'
            open_brackets += 1
            @token << c
          when '@'
            if nc =~ /[a-z_]/i
              pass_state[]
              push_state[:object_variable]
            else
              @token << c
            end
          when '"'
            pass_state[]
            push_state[:string]
          when /[0-9]/
            if c == '0' && nc == 'x'
              pass_state[:repeat]
              push_state[:object_address]
            else
              # push_state[:number, :repeat]
              @token << c
            end
          else
            @token << c
          end

        when :object_variable
          if c =~ /[a-z0-9_]/i
            @token << c
          else
            pass[:object_variable_prefix, '@']
            pass_state[:remove]
            pass[:object_description, '=']
            push_state[:variable]
          end

        when :object_address
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
          elsif c == '>' # e.g. RubyVM
            pass_state[:remove, :repeat]
          else
            @token << c
          end

        when :object_line_number
          if c =~ /[0-9]/
            @token << c
          else
            pass_state[:remove, :repeat]
          end

        when :equal
          if c == '>' && lc == '='
            @token = ''; pop_state[] # TODO in pass helper
            if get_state[:hash]
              if nc == '=' || @refers_seen[-1]
                pass[:symbol, '=>']
              else
                pass[:refers, '=>']
                @refers_seen[-1] = true
              end
            else # MAYBE remove this <=> cheat
              pass[:symbol, '=>']
            end
          elsif c =~ /\S/
            @token << c
          else
            pass[:whitespace, c]
          end

        when :instructionsequence # RubyVM
          if c =~ /[^@]/i
            @token << c
          else
            pass[:object_line_prefix, @token + '@']
            @token = ''
            set_state[:object_line]
          end

        else
          raise "unknown state #{@state[-1]} #{@state.inspect}"
        end

        # next round
        if !@repeat
          i += 1
        elsif snapshot && Marshal.load(snapshot) == [@state, @token, llc, lc, c, nc] # loop protection
          raise "This might be a WIRB bug, please open an issue at:\nhttps://github.com/janlelis/wirb/issues/new"
        end

        snapshot = Marshal.dump([@state, @token, llc, lc, c, nc])
      end
    end
  end
end

# J-_-L
