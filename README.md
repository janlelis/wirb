## WIRB Interactive Ruby [![version](https://badge.fury.io/rb/wirb.svg)](https://badge.fury.io/rb/wirb) [<img src="https://travis-ci.org/janlelis/wirb.png" />](https://travis-ci.org/janlelis/wirb)

The **WIRB** gem syntax highlights Ruby objects. Works best as your default REPL inspector (see usage section below), but does not require IRB.

Supported Rubies: 2.7, 2.6, 2.5, 2.4

Older Rubies, should work: 2.3, 2.2, 2.1, 2.0, rubinius

Ancient Rubies (1.9, 1.8): Please use [WIRB 1.0](https://github.com/janlelis/wirb/tree/1.0.3)

[See it in action](https://travis-ci.org/janlelis/wirb/jobs/56299603)


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

Another way would be to use [Irbtools](https://irb.tools), which activate WIRB automatically.

## `Kernel#wp`

WIRB comes with a pretty printing utility (similar to awesome_print):

    require 'wirb/wp'
    wp some_object

### Bundled Schemas

These are the bundled color schemas. You can load one with `Wirb.load_schema(:name)`

* `:classic` (default)
* `:colorless` (only uses :bright, :underline and :inverse effect)
* `:ultra` (by @venantius, matches the colorscheme from [Ultra](https://github.com/venantius/ultra) over in Clojure-land)

### Usage with Rails

If you run into problems using WIRB with Rails, try [the solution in this issue](https://github.com/janlelis/wirb/issues/12#issuecomment-249492524).

## Also See

* Gem that allows you to configure views for specific objects:
  [hirb](https://github.com/cldwalker/hirb)
* WIRB is part of: [Irbtools](https://github.com/janlelis/irbtools)
* More about terminal colors: [Paint](https://github.com/janlelis/paint)

## Credits

Copyright (c) 2011-2019 Jan Lelis <https://janlelis.com> see COPYING for details.

First tokenizer version was based on the [wirble](https://rubygems.org/gems/wirble) gem:
Copyright (C) 2006-2009 Paul Duncan <pabs@pablotron.org>

[All contributors](https://github.com/janlelis/wirb/contributors)
