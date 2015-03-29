## WIRB Interactive Ruby [![version](https://badge.fury.io/rb/wirb.svg)](http://badge.fury.io/rb/wirb) [<img src="https://travis-ci.org/janlelis/wirb.png" />](https://travis-ci.org/janlelis/wirb)

**WIRB** syntax highlights Ruby objects.

Supported Rubies: 2.2, 2.1, 2.0, jruby, rubinius.

Legacy Rubies (1.9, 1.8): Use [WIRB 1.0](https://github.com/janlelis/wirb/tree/1.0.3)

[Example output](https://travis-ci.org/janlelis/wirb/jobs/56299603)


## Features

* Syntax highlighting for Ruby objects
* No monkey patches anywhere
* Support for generic objects, especially enumerators, and nested generic
  objects
* Can be used without IRB
* Supports stdlib objects, like `Set`
* Custom color schemas via YAML

## Install

Install the gem with:

    $ gem install wirb

## Usage

To start IRB with WIRB activated for one session, do:

    $ irb -r wirb --inspect wirb

To activate WIRB permanently, you'll need to add this to the `~/.irbrc` file:

    require 'wirb'
    Wirb.start

### Bundled Schemas

These are the bundled color schemas. You can load one with `Wirb.load_schema
:name`

* `:classic` (default)
* `:colorless` (only uses :bright, :underline and :inverse effect)


## `Kernel#wp`

You can use WIRB like awesome_print to highlight any objects using `wp`:

    require 'wirb/wp'
    wp some_object

## Also See

* Gem that allows you to configure views for specific objects:
  [hirb](https://github.com/cldwalker/hirb)
* WIRB is part of: [irbtools](https://github.com/janlelis/irbtools)
* RIPL is an IRB alternative, syntax highlighting plugin (uses wirb by
  default):
  [ripl-color_result](https://github.com/janlelis/ripl-color_result)
* More about terminal colors: [Paint](https://github.com/janlelis/paint)
* [Wirble](http://pablotron.org/software/wirble/): WIRB's predecessor


## Credits

Copyright (c) 2011-2015 Jan Lelis <http://janlelis.com> see COPYING for
details.

Influenced by code from: Copyright (C) 2006-2009 Paul Duncan
<pabs@pablotron.org>

[All contributors](https://github.com/janlelis/wirb/contributors)
