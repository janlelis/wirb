require_relative '../wirb' unless defined? Wirb
require 'irb'

IRB::Inspector.def_inspector(:wirb, &Wirb::INSPECTOR)
