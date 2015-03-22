# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/wirb/version"

Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION.dup
  s.authors     = ["Jan Lelis"]
  s.email       = "mail@janlelis.de"
  s.homepage    = "https://github.com/janlelis/wirb"
  s.summary     = "WIRB Interactive Ruby"
  s.description =  "WIRB highlights inspected Ruby objects. It is based on the original Wirble. You can create new color schemas using yaml."
  s.required_ruby_version = '~> 2.0'
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} data/**/*.yml]) + %w{Rakefile wirb.gemspec .gemtest}
  s.extra_rdoc_files = ["README.rdoc", "COPYING.txt"]
  s.license = 'MIT'
  s.add_dependency 'paint', '= 1.0.0.pre'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'zucker', '~> 13'
  #s.add_development_dependency 'highline'
end
