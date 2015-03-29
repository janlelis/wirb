## 2.0.0
### Main Changes
* Don't target Ruby 1 anymore, set required Ruby version to 2.0
* Change the way WIRB is integrated into IRB: Now uses the IRB API, instead
  of monkey patch
* Remove abstraction for alternative colorizers, only use paint
* Introduce timeout option: If WIRB hasn't finised applying colors within 3
  seconds, it will skip rendering the string
* Support rubinius enumerators

### Minor Changes
* Rename :keyword token to :word (e.g. main) and more token renamings
* Simplify setting delimiters in schema (e.g. :array instead of :open_array
  and :close_array)
* Move exception handling out of tokenizer
* Remove parsing rules for 1.8 and rubygem dependencies
* Fix that @instance variables beginning with underscore get detected

## 1.0.3
* Allow nestings of objects in object description

## 1.0.2
* Fix a bug that would load wirb irb hooks in non irb environments

## 1.0.0 / 1.0.1
* Paint gem is a dependency

## 0.5.0
* Use magenta instead of black for strings (better readable)
* Fix bug with StringScanner objects
* Support complex numbers
* Support Infinity and NaN as valid numbers
* Default colorizer is now Paint

## 0.4.2
* Fix a symbol string bug
* Don't fail on nil input for Wirb.tokenize

## 0.4.1
* New bundled color schema: colorless (use at least Paint version 0.8.2)
* Fix minor bugs of 0.4.0

## 0.4.0
* Add support for loading color schemas from yaml files
* Add ability to hook in a custom colorizer
  * Support for Paint, HighLine (1.6.3), old Wirb color names (Wirb0) and
    even older Wirble color names
  * Wirb0(-like) colors are still default, but will be dropped (as
    default) in 1.0
  * Provides hybrid connectors to Paint and HighLine that also enable Wirb
    colors (Wirb0_Paint, Wirb0_HighLine)
*   Only display error on failed tokenizations if $VERBOSE is not false

## 0.3.2
* Improve :<=> parsing :D
* Support gem requirements (:gem_requirement_condition,
  :gem_requirement_version) and gem dependencies

## 0.3.1
* Fix ;$., ;$", :$,

## 0.3.0
* Improve 1.9 enumerator detection/highlighting
  * Remove :open_enumerator / :close_enumerator (use nested usual base
    objects instead)
* Support timestamps (:timestamp)
* Support instance variables and their contents (:object_variable,
  :object_variable_prefix)
* Add Wirb.stop to not colorize anything, anymore (in irb)
* Support RubyVM instruction sequences

## 0.2.6
* Fix Ruby 1.8 "already initialized constant" warnings

## 0.2.5
* Fix wrong \ escaping
* Fix stupid rescue bug (no more wirb crashes)

## 0.2.3 / 0.2.4
* Support for rubygems-test <gem-testers.org>

## 0.2.2
* Always return inspected string (even when errors happen) and endless-loop
  protection
* Recognize active record class descriptions

## 0.2.1
* Fix 1.8 Rational after requiring 'mathn'
* Return of string if tokenizer throws an error

## 0.2.0
* Initial release.

