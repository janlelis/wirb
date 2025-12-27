## WIRB Interactive Ruby [![version](https://badge.fury.io/rb/wirb.svg)](https://badge.fury.io/rb/wirb) [<img src="https://github.com/janlelis/wirb/workflows/Test/badge.svg" />](https://github.com/janlelis/wirb/actions?query=workflow%3ATest)

The **WIRB** gem adds syntax highlighting to inspected Ruby objects. It covers core Ruby classes/modules and most of standard library. Works best as your default REPL inspector, but also works without IRB.

Supports Ruby 3.x and 4.0.

Please note that WIRB also works well for Ruby 1 and Ruby 2 - just install the latest WIRB version possible to install.

## Features

* Syntax highlighting for inspected Ruby objects
* No monkey patches anywhere
* Support for generic objects, especially enumerators, and nested generic objects
* Supports common standard library objects, like `Set`
* Color schemas customizable via YAML

## Install

Install the gem with:

    $ gem install wirb

Or add it to your Gemfile:

   gem 'wirb'

## Usage

To start IRB with WIRB activated for one session, do:

    $ irb -r wirb --inspect wirb

To activate WIRB permanently, you can add this to the `~/.irbrc` file:

    require 'wirb'
    Wirb.start

Another way would be to use [Irbtools](https://github.com/janlelis/irbtools), which activates WIRB automatically.

## `Kernel#wp`

WIRB comes with a pretty printing utility:

    require 'wirb/wp'
    wp some_object

Other than similar tools like *pp* or *awesome_print*, it will not change the format the highlighted objects by adding whitespace, but only adds colors.

### Bundled Schemas

These are the bundled color schemas. You can load one with `Wirb.load_schema(:name)`

* `:classic` (default)
* `:colorless` (only uses :bright, :underline and :inverse effect)
* `:ultra` (by @venantius, matches the colorscheme from [Ultra](https://github.com/venantius/ultra) over in Clojure-land)


## Also See

* WIRB is part of: [Irbtools](https://github.com/janlelis/irbtools)
* More about terminal colors: [Paint](https://github.com/janlelis/paint)

## Credits

Copyright (c) 2011-2025 Jan Lelis <https://janlelis.com> see COPYING for details.

First tokenizer version was based on the [wirble](https://rubygems.org/gems/wirble) gem:
Copyright (C) 2006-2009 Paul Duncan <pabs@pablotron.org>

[All contributors](https://github.com/janlelis/wirb/contributors)
