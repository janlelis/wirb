# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/wirb/version"
 
Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "http://github.com/janlelis/wirb"
  s.summary     = "Colorizes your irb results."
  s.description =  "Colorizes your irb results. It's based on Wirble but only provides result highlighting. Just call Wirb.start and enjoy the colors ;)."
  s.required_rubygems_version = '>= 1.3.6'
  s.required_ruby_version     = '>= 1.8.7'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c}]) + %w{Rakefile wirb.gemspec .gemtest}
  s.extra_rdoc_files = ["README.rdoc", "COPYING.txt"]
  s.license = 'MIT'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'zucker', '>=9'
end
