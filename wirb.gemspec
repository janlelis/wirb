# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/wirb/version"

Gem::Specification.new do |s|
  s.name        = "wirb"
  s.version     = Wirb::VERSION.dup
  s.authors     = ["Jan Lelis"]
  s.email       = ["hi@ruby.consulting"]
  s.homepage    = "https://github.com/janlelis/wirb"
  s.summary     = "WIRB Interactive Ruby"
  s.description =  "WIRB syntax highlights inspected Ruby objects"
  s.files = Dir.glob(%w[{lib,test,spec}/**/*.rb bin/* [A-Z]*.{txt,md} ext/**/*.{rb,c} data/**/*.yml]) + %w{Rakefile wirb.gemspec}
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md", "COPYING.txt"]
  s.license     = 'MIT'
  s.metadata    = { "rubygems_mfa_required" => "true" }
  s.required_ruby_version = '>= 2.0', '< 4.0'
  s.add_dependency 'paint', '>= 0.9', '< 4.0'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'ruby_engine', '~> 1.0'
end
