# -*- encoding: utf-8 -*-
require 'rubygems' unless defined? Gem
require File.dirname(__FILE__) + "/lib/wirb/version"

Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION.dup
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/wirb"
  s.summary     = "Wirb Interactive Ruby"
  s.description =  "Wirb colorizes your inspected Ruby objects. It is based on Wirble, but only provides and improves result highlighting. It also provides a colorization engine abstraction layer and offers flexible schemas using yaml. Wirb is part of the irbtools suite."
  s.required_ruby_version     = '>= 1.8.7'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} data/**/*.yml]) + %w{Rakefile wirb.gemspec .gemtest}
  s.extra_rdoc_files = ["README.rdoc", "COPYING.txt"]
  s.license = 'MIT'
  s.add_dependency 'paint', '~> 0.8'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'zucker', '~> 13'
  #s.add_development_dependency 'highline'
end
